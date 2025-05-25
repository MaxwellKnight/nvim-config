if exists('b:current_syntax')
  finish
endif

" -- Keywords --
syn keyword mylangKeyword def returns return var begin end call if elif else while for do and or not null TRUE FALSE

" -- Types and pointers --
syn keyword mylangType bool char int real string
syn match   mylangPointer "\<\(int\|char\|real\)\*\>"

" -- Numbers (hex, floats, ints) --
syn match   mylangNumber "\v0x[0-9A-Fa-f]+"
syn match   mylangNumber "\v(\d+\.\d*([eE][+-]?\d+)?|\.\d+([eE][+-]?\d+)?|\d+[eE][+-]?\d+)"
syn match   mylangNumber "\v\d+"

" -- Strings and characters --
syn region  mylangString start=+"+ skip=+\\\\\|\\"+ end=+"+
syntax match mylangCharacter "'.'"

" -- Operators --
syn match mylangOperator "[\+\-\*/=<>!&|]\+"

" -- Comments --
syn region mylangComment start="#->" end="<-#"

" -- Identifiers --
syn match mylangIdentifier "\<[A-Za-z][A-Za-z0-9_]*\>"

" -- Highlight links --
hi def link mylangKeyword Keyword
hi def link mylangType    Type
hi def link mylangPointer Type
hi def link mylangNumber  Number
hi def link mylangString  String
hi def link mylangCharacter Character
hi def link mylangOperator Operator
hi def link mylangComment  Comment
hi def link mylangIdentifier Identifier

let b:current_syntax = "mylang"
