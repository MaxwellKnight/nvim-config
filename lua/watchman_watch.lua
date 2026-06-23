-- Watchman-backed file watcher for Neovim's LSP didChangeWatchedFiles.
--
-- Why this exists: on macOS, nvim 0.11's built-in backends (vim._watch.watch
-- and .watchdirs) both open one libuv fs_event handle PER directory. In large
-- repos (Rust target/, node_modules/) this exhausts the open-file limit and
-- crashes vim/_watch.lua with EMFILE. The watchman daemon instead watches the
-- whole tree through a single efficient FSEvents stream, so Neovim holds zero
-- per-directory fds.
--
-- Strategy: no persistent subscription stream (which would need fragile
-- incremental JSON parsing). Instead we ask the daemon, on a debounce timer,
-- "what changed since this clock?" via a one-shot `watchman -j` query. Each
-- call returns exactly one complete JSON PDU.

local uv = vim.uv
local M = {}

local FileChangeType = { Created = 1, Changed = 2, Deleted = 3 }

-- Set true the first time watchman fails (e.g. FSEventStreamStart broken on
-- this machine). Once degraded, every M.watch call becomes a silent no-op so we
-- don't spam a warning per registered path (rust-analyzer registers the
-- workspace root plus each crate). Resets on nvim restart, so the bridge
-- auto-recovers if watchman starts working later.
local degraded = false

--- Run a single watchman JSON command. `cmd` is a Lua table encoded to stdin.
--- `on_done(decoded|nil, err)` is invoked with the parsed response.
local function watchman(cmd, on_done)
  vim.system(
    { 'watchman', '-j', '--no-pretty' },
    { stdin = vim.json.encode(cmd), text = true },
    function(res)
      if res.code ~= 0 or not res.stdout or res.stdout == '' then
        return on_done(nil, res.stderr or ('exit ' .. tostring(res.code)))
      end
      local ok, decoded = pcall(vim.json.decode, res.stdout)
      if not ok then
        return on_done(nil, decoded)
      end
      if decoded.error then
        return on_done(nil, decoded.error)
      end
      return on_done(decoded)
    end
  )
end

--- Mirror of vim._watch's include/exclude filtering.
local function skip(path, opts)
  if not opts then
    return false
  end
  if opts.include_pattern and opts.include_pattern:match(path) == nil then
    return true
  end
  if opts.exclude_pattern and opts.exclude_pattern:match(path) ~= nil then
    return true
  end
  return false
end

--- Drop-in replacement for vim._watch.watch / .watchdirs.
--- @param path string directory to watch
--- @param opts table|nil { debounce?, include_pattern?, exclude_pattern? }
--- @param callback fun(fullpath: string, change_type: integer)
--- @return fun() cancel
function M.watch(path, opts, callback)
  vim.validate('path', path, 'string')
  vim.validate('callback', callback, 'function')
  if degraded then
    return function() end
  end
  opts = opts or {}
  path = vim.fs.normalize(path)

  local debounce = opts.debounce or 1000
  local stopped = false
  local in_flight = false
  local clock = nil --- @type string|nil
  local root = nil --- @type string|nil
  local rel = nil --- @type string|nil   subdir of the watched root, if any

  -- Resolve the watched root + starting clock, then begin polling.
  watchman({ 'watch-project', path }, function(proj, err)
    if stopped then
      return
    end
    if not proj or not proj.watch then
      -- watchman is unusable on this machine (commonly FSEventStreamStart).
      -- Degrade to a silent no-op for the rest of the session and tell the user
      -- exactly once, with a short single-line message so it never triggers the
      -- hit-enter prompt.
      if not degraded then
        degraded = true
        vim.schedule(function()
          vim.notify_once(
            'watchman unavailable; LSP file-watching disabled this session',
            vim.log.levels.WARN
          )
        end)
      end
      return
    end
    root = proj.watch
    rel = proj.relative_path -- nil when `path` is the watch root itself

    watchman({ 'clock', root }, function(clk)
      if not stopped then
        clock = (clk and clk.clock) or 'c:0:0'
      end
    end)
  end)

  local timer = assert(uv.new_timer())

  local function poll()
    if stopped or in_flight or not root or not clock then
      return
    end
    in_flight = true

    local query = { since = clock, fields = { 'name', 'exists', 'new' } }
    if rel and rel ~= '' then
      query.relative_root = rel
    end

    watchman({ 'query', root, query }, function(qres, err)
      in_flight = false
      if stopped or not qres then
        if err then
          vim.schedule(function()
            vim.notify_once('watchman: query failed: ' .. tostring(err), vim.log.levels.DEBUG)
          end)
        end
        return
      end
      if qres.clock then
        clock = qres.clock
      end
      -- A fresh instance returns the ENTIRE tree; don't flood the server.
      if qres.is_fresh_instance then
        return
      end

      local base = (rel and rel ~= '') and vim.fs.joinpath(root, rel) or root
      for _, f in ipairs(qres.files or {}) do
        local fullpath = vim.fs.normalize(vim.fs.joinpath(base, f.name))
        if not skip(fullpath, opts) then
          local change_type
          if not f.exists then
            change_type = FileChangeType.Deleted
          elseif f['new'] then
            change_type = FileChangeType.Created
          else
            change_type = FileChangeType.Changed
          end
          vim.schedule(function()
            if not stopped then
              callback(fullpath, change_type)
            end
          end)
        end
      end
    end)
  end

  timer:start(debounce, debounce, poll)

  return function()
    stopped = true
    if not timer:is_closing() then
      timer:stop()
      timer:close()
    end
  end
end

return M
