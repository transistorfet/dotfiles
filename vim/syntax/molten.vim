" Vim syntax file
" Language:     Molten
" Filenames:    *.mlt
" Maintainers:  Markus Mottl      <markus.mottl@gmail.com>
"               Karl-Heinz Sylla  <Karl-Heinz.Sylla@gmd.de>
"               Issac Trotts      <ijtrotts@ucdavis.edu>
" URL:          http://www.ocaml.info/vim/syntax/ocaml.vim
" Last Change:  2018 Mar 01 - Modified for Molten
"               2012 May 12 - Added Dominique Pellé's spell checking patch (MM)
"               2012 Feb 01 - Improved module path highlighting (MM)
"               2010 Oct 11 - Added highlighting of lnot (MM, thanks to Erick Matsen)

" A minor patch was applied to the official version so that object/end
" can be distinguished from begin/end, which is used for indentation,
" and folding. (David Baelde)

" quit when a syntax file was already loaded
if exists("b:current_syntax") && b:current_syntax == "molten"
  finish
endif

" Molten is case sensitive.
syn case match

" Access to the method of an object
syn match    moltenMethod       "#"

" Script headers highlighted like comments
syn match    moltenComment   "^//.*" contains=@Spell

" Scripting directives
syn match    moltenScript "^#\<\(quit\|labels\|warnings\|directory\|cd\|load\|use\|install_printer\|remove_printer\|require\|thread\|trace\|untrace\|untrace_all\|print_depth\|print_length\|camlp4o\)\>"

" lowercase identifier - the standard way to match
syn match    moltenLCIdentifier /\<\(\l\|_\)\(\w\|'\)*\>/

syn match    moltenKeyChar    "|"

" Errors
syn match    moltenBraceErr   "}"
syn match    moltenBrackErr   "\]"
syn match    moltenParenErr   ")"
syn match    moltenArrErr     "|]"

syn match    moltenCommentErr "\*)"

syn match    moltenCountErr   "\<downto\>"
syn match    moltenCountErr   "\<to\>"

if !exists("molten_revised")
  syn match    moltenDoErr      "\<do\>"
endif

syn match    moltenDoneErr    "\<done\>"
syn match    moltenThenErr    "\<then\>"

" Error-highlighting of "end" without synchronization:
" as keyword or as error (default)
if exists("molten_noend_error")
  syn match    moltenKeyword    "\<end\>"
else
  syn match    moltenEndErr     "\<end\>"
endif

" Some convenient clusters
syn cluster  moltenAllErrs contains=moltenBraceErr,moltenBrackErr,moltenParenErr,moltenCommentErr,moltenCountErr,moltenDoErr,moltenDoneErr,moltenEndErr,moltenThenErr

syn cluster  moltenAENoParen contains=moltenBraceErr,moltenBrackErr,moltenCommentErr,moltenCountErr,moltenDoErr,moltenDoneErr,moltenEndErr,moltenThenErr

syn cluster  moltenContained contains=moltenTodo,moltenPreDef,moltenModParam,moltenModParam1,moltenPreMPRestr,moltenMPRestr,moltenMPRestr1,moltenMPRestr2,moltenMPRestr3,moltenModRHS,moltenFuncWith,moltenFuncStruct,moltenModTypeRestr,moltenModTRWith,moltenWith,moltenWithRest,moltenModType,moltenFullMod,moltenVal


" Enclosing delimiters
syn region   moltenEncl transparent matchgroup=moltenKeyword start="(" matchgroup=moltenKeyword end=")" contains=ALLBUT,@moltenContained,moltenParenErr
syn region   moltenEncl transparent matchgroup=moltenKeyword start="{" matchgroup=moltenKeyword end="}"  contains=ALLBUT,@moltenContained,moltenBraceErr
syn region   moltenEncl transparent matchgroup=moltenKeyword start="\[" matchgroup=moltenKeyword end="\]" contains=ALLBUT,@moltenContained,moltenBrackErr
syn region   moltenEncl transparent matchgroup=moltenKeyword start="\[|" matchgroup=moltenKeyword end="|\]" contains=ALLBUT,@moltenContained,moltenArrErr


" Comments
syn region   moltenComment start="(\*" end="\*)" contains=@Spell,moltenComment,moltenTodo
syn keyword  moltenTodo contained TODO FIXME XXX NOTE


" Objects
syn region   moltenEnd matchgroup=moltenObject start="\<object\>" matchgroup=moltenObject end="\<end\>" contains=ALLBUT,@moltenContained,moltenEndErr


" Blocks
if !exists("molten_revised")
  syn region   moltenEnd matchgroup=moltenKeyword start="\<begin\>" matchgroup=moltenKeyword end="\<end\>" contains=ALLBUT,@moltenContained,moltenEndErr
endif


" "for"
syn region   moltenNone matchgroup=moltenKeyword start="\<for\>" matchgroup=moltenKeyword end="\<\(to\|downto\)\>" contains=ALLBUT,@moltenContained,moltenCountErr


" "do"
if !exists("molten_revised")
  syn region   moltenDo matchgroup=moltenKeyword start="\<do\>" matchgroup=moltenKeyword end="\<done\>" contains=ALLBUT,@moltenContained,moltenDoneErr
endif

" "if"
syn region   moltenNone matchgroup=moltenKeyword start="\<if\>" matchgroup=moltenKeyword end="\<then\>" contains=ALLBUT,@moltenContained,moltenThenErr


"" Modules

" "sig"
syn region   moltenSig matchgroup=moltenModule start="\<sig\>" matchgroup=moltenModule end="\<end\>" contains=ALLBUT,@moltenContained,moltenEndErr,moltenModule
syn region   moltenModSpec matchgroup=moltenKeyword start="\<module\>" matchgroup=moltenModule end="\<\u\(\w\|'\)*\>" contained contains=@moltenAllErrs,moltenComment skipwhite skipempty nextgroup=moltenModTRWith,moltenMPRestr

" "open"
syn region   moltenNone matchgroup=moltenKeyword start="\<open\>" matchgroup=moltenModule end="\<\u\(\w\|'\)*\( *\. *\u\(\w\|'\)*\)*\>" contains=@moltenAllErrs,moltenComment

" "include"
syn match    moltenKeyword "\<include\>" skipwhite skipempty nextgroup=moltenModParam,moltenFullMod

" "module" - somewhat complicated stuff ;-)
syn region   moltenModule matchgroup=moltenKeyword start="\<module\>" matchgroup=moltenModule end="\<\u\(\w\|'\)*\>" contains=@moltenAllErrs,moltenComment skipwhite skipempty nextgroup=moltenPreDef
syn region   moltenPreDef start="."me=e-1 matchgroup=moltenKeyword end="\l\|=\|)"me=e-1 contained contains=@moltenAllErrs,moltenComment,moltenModParam,moltenModTypeRestr,moltenModTRWith nextgroup=moltenModPreRHS
syn region   moltenModParam start="([^*]" end=")" contained contains=@moltenAENoParen,moltenModParam1,moltenVal
syn match    moltenModParam1 "\<\u\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=moltenPreMPRestr

syn region   moltenPreMPRestr start="."me=e-1 end=")"me=e-1 contained contains=@moltenAllErrs,moltenComment,moltenMPRestr,moltenModTypeRestr

syn region   moltenMPRestr start=":" end="."me=e-1 contained contains=@moltenComment skipwhite skipempty nextgroup=moltenMPRestr1,moltenMPRestr2,moltenMPRestr3
syn region   moltenMPRestr1 matchgroup=moltenModule start="\ssig\s\=" matchgroup=moltenModule end="\<end\>" contained contains=ALLBUT,@moltenContained,moltenEndErr,moltenModule
syn region   moltenMPRestr2 start="\sfunctor\(\s\|(\)\="me=e-1 matchgroup=moltenKeyword end="->" contained contains=@moltenAllErrs,moltenComment,moltenModParam skipwhite skipempty nextgroup=moltenFuncWith,moltenMPRestr2
syn match    moltenMPRestr3 "\w\(\w\|'\)*\( *\. *\w\(\w\|'\)*\)*" contained
syn match    moltenModPreRHS "=" contained skipwhite skipempty nextgroup=moltenModParam,moltenFullMod
syn keyword  moltenKeyword val
syn region   moltenVal matchgroup=moltenKeyword start="\<val\>" matchgroup=moltenLCIdentifier end="\<\l\(\w\|'\)*\>" contains=@moltenAllErrs,moltenComment,moltenFullMod skipwhite skipempty nextgroup=moltenMPRestr
syn region   moltenModRHS start="." end=". *\w\|([^*]"me=e-2 contained contains=moltenComment skipwhite skipempty nextgroup=moltenModParam,moltenFullMod
syn match    moltenFullMod "\<\u\(\w\|'\)*\( *\. *\u\(\w\|'\)*\)*" contained skipwhite skipempty nextgroup=moltenFuncWith

syn region   moltenFuncWith start="([^*]"me=e-1 end=")" contained contains=moltenComment,moltenWith,moltenFuncStruct skipwhite skipempty nextgroup=moltenFuncWith
syn region   moltenFuncStruct matchgroup=moltenModule start="[^a-zA-Z]struct\>"hs=s+1 matchgroup=moltenModule end="\<end\>" contains=ALLBUT,@moltenContained,moltenEndErr

syn match    moltenModTypeRestr "\<\w\(\w\|'\)*\( *\. *\w\(\w\|'\)*\)*\>" contained
syn region   moltenModTRWith start=":\s*("hs=s+1 end=")" contained contains=@moltenAENoParen,moltenWith
syn match    moltenWith "\<\(\u\(\w\|'\)* *\. *\)*\w\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=moltenWithRest
syn region   moltenWithRest start="[^)]" end=")"me=e-1 contained contains=ALLBUT,@moltenContained

" "struct"
syn region   moltenStruct matchgroup=moltenModule start="\<\(module\s\+\)\=struct\>" matchgroup=moltenModule end="\<end\>" contains=ALLBUT,@moltenContained,moltenEndErr

" "module type"
syn region   moltenKeyword start="\<module\>\s*\<type\>\(\s*\<of\>\)\=" matchgroup=moltenModule end="\<\w\(\w\|'\)*\>" contains=moltenComment skipwhite skipempty nextgroup=moltenMTDef
syn match    moltenMTDef "=\s*\w\(\w\|'\)*\>"hs=s+1,me=s+1 skipwhite skipempty nextgroup=moltenFullMod

syn keyword  moltenKeyword  and as assert class
syn keyword  moltenKeyword  constraint else
syn keyword  moltenKeyword  exception external fun

syn keyword  moltenKeyword  in inherit initializer
syn keyword  moltenKeyword  land lazy let match
syn keyword  moltenKeyword  method mutable new of
syn keyword  moltenKeyword  parser private raise rec
syn keyword  moltenKeyword  try type
syn keyword  moltenKeyword  virtual when while with

if exists("molten_revised")
  syn keyword  moltenKeyword  do value
  syn keyword  moltenBoolean  True False
else
  syn keyword  moltenKeyword  function
  syn keyword  moltenBoolean  true false
  syn match    moltenKeyChar  "!"
endif

syn keyword  moltenType     array bool char exn float format format4
syn keyword  moltenType     int int32 int64 lazy_t list nativeint option
syn keyword  moltenType     string unit

syn keyword  moltenOperator asr lnot lor lsl lsr lxor mod not

syn match    moltenConstructor  "(\s*)"
syn match    moltenConstructor  "\[\s*\]"
syn match    moltenConstructor  "\[|\s*>|]"
syn match    moltenConstructor  "\[<\s*>\]"
syn match    moltenConstructor  "\u\(\w\|'\)*\>"

" Polymorphic variants
syn match    moltenConstructor  "`\w\(\w\|'\)*\>"

" Module prefix
syn match    moltenModPath      "\u\(\w\|'\)* *\."he=e-1

syn match    moltenCharacter    "'\\\d\d\d'\|'\\[\'ntbr]'\|'.'"
syn match    moltenCharacter    "'\\x\x\x'"
syn match    moltenCharErr      "'\\\d\d'\|'\\\d'"
syn match    moltenCharErr      "'\\[^\'ntbr]'"
syn region   moltenString       start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell

syn match    moltenFunDef       "->"
syn match    moltenRefAssign    ":="
syn match    moltenTopStop      ";;"
syn match    moltenOperator     "\^"
syn match    moltenOperator     "::"

syn match    moltenOperator     "&&"
syn match    moltenOperator     "<"
syn match    moltenOperator     ">"
syn match    moltenAnyVar       "\<_\>"
syn match    moltenKeyChar      "|[^\]]"me=e-1
syn match    moltenKeyChar      ";"
syn match    moltenKeyChar      "\~"
syn match    moltenKeyChar      "?"
syn match    moltenKeyChar      "\*"
syn match    moltenKeyChar      "="

if exists("molten_revised")
  syn match    moltenErr        "<-"
else
  syn match    moltenOperator   "<-"
endif

syn match    moltenNumber        "\<-\=\d\(_\|\d\)*[l|L|n]\?\>"
syn match    moltenNumber        "\<-\=0[x|X]\(\x\|_\)\+[l|L|n]\?\>"
syn match    moltenNumber        "\<-\=0[o|O]\(\o\|_\)\+[l|L|n]\?\>"
syn match    moltenNumber        "\<-\=0[b|B]\([01]\|_\)\+[l|L|n]\?\>"
syn match    moltenFloat         "\<-\=\d\(_\|\d\)*\.\?\(_\|\d\)*\([eE][-+]\=\d\(_\|\d\)*\)\=\>"

" Labels
syn match    moltenLabel        "\~\(\l\|_\)\(\w\|'\)*"lc=1
syn match    moltenLabel        "?\(\l\|_\)\(\w\|'\)*"lc=1
syn region   moltenLabel transparent matchgroup=moltenLabel start="?(\(\l\|_\)\(\w\|'\)*"lc=2 end=")"me=e-1 contains=ALLBUT,@moltenContained,moltenParenErr


" Synchronization
syn sync minlines=50
syn sync maxlines=500

if !exists("molten_revised")
  syn sync match moltenDoSync      grouphere  moltenDo      "\<do\>"
  syn sync match moltenDoSync      groupthere moltenDo      "\<done\>"
endif

if exists("molten_revised")
  syn sync match moltenEndSync     grouphere  moltenEnd     "\<\(object\)\>"
else
  syn sync match moltenEndSync     grouphere  moltenEnd     "\<\(begin\|object\)\>"
endif

syn sync match moltenEndSync     groupthere moltenEnd     "\<end\>"
syn sync match moltenStructSync  grouphere  moltenStruct  "\<struct\>"
syn sync match moltenStructSync  groupthere moltenStruct  "\<end\>"
syn sync match moltenSigSync     grouphere  moltenSig     "\<sig\>"
syn sync match moltenSigSync     groupthere moltenSig     "\<end\>"

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

hi def link moltenBraceErr	   Error
hi def link moltenBrackErr	   Error
hi def link moltenParenErr	   Error
hi def link moltenArrErr	   Error

hi def link moltenCommentErr   Error

hi def link moltenCountErr	   Error
hi def link moltenDoErr	   Error
hi def link moltenDoneErr	   Error
hi def link moltenEndErr	   Error
hi def link moltenThenErr	   Error

hi def link moltenCharErr	   Error

hi def link moltenErr	   Error

hi def link moltenComment	   Comment

hi def link moltenModPath	   Include
hi def link moltenObject	   Include
hi def link moltenModule	   Include
hi def link moltenModParam1    Include
hi def link moltenModType	   Include
hi def link moltenMPRestr3	   Include
hi def link moltenFullMod	   Include
hi def link moltenModTypeRestr Include
hi def link moltenWith	   Include
hi def link moltenMTDef	   Include

hi def link moltenScript	   Include

hi def link moltenConstructor  Constant

hi def link moltenVal          Keyword
hi def link moltenModPreRHS    Keyword
hi def link moltenMPRestr2	   Keyword
hi def link moltenKeyword	   Keyword
hi def link moltenMethod	   Include
hi def link moltenFunDef	   Keyword
hi def link moltenRefAssign    Keyword
hi def link moltenKeyChar	   Keyword
hi def link moltenAnyVar	   Keyword
hi def link moltenTopStop	   Keyword
hi def link moltenOperator	   Keyword

hi def link moltenBoolean	   Boolean
hi def link moltenCharacter    Character
hi def link moltenNumber	   Number
hi def link moltenFloat	   Float
hi def link moltenString	   String

hi def link moltenLabel	   Identifier

hi def link moltenType	   Type

hi def link moltenTodo	   Todo

hi def link moltenEncl	   Keyword


let b:current_syntax = "molten"

" vim: ts=8
