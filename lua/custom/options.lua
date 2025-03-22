-- [[ Setting options ]]
local opt = vim.opt

-- [[ Editor behavior ]]
opt.tabstop = 2
opt.shiftwidth = 2
opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.showmode = false
opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true
opt.guicursor = ''

-- [[ Search ]]
opt.ignorecase = true
opt.smartcase = true

-- [[ UI options ]]
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
opt.inccommand = 'split'
opt.cursorline = false
opt.scrolloff = 10
opt.hlsearch = true
