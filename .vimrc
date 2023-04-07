
set nocompatible

" Activate the vim package manager, pathogen
execute pathogen#infect()

set ff=unix
set encoding=utf-8
set nowrap
behave xterm

set title               " show filename in the window title
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hlsearch		" highlight search terms
set number              " show line numbers
set showtabline=1	" only show tab bar if more than one tab
set laststatus=2	" always show the status bar

set backspace=indent,eol,start whichwrap+=<,>,[,]       " backspace and cursor keys wrap to previous/next line

set history=100		" lines of command line history to keep
set undofile            " enable persistent undo
set undodir=~/.vimundo
"set backup		" keep a backup file
"set smartcase          " if search is lowercase, ignorecase, otherwise case-sensitive

set mouse=a             " enable mouse in all modes
set ttymouse=xterm2     " hack for tmux to fix mouse movements in vim through tmux

set sessionoptions=buffers,curdir,tabpages,winsize

let g:asyncomplete_auto_popup = 0               " Don't open the autocomplete until Ctrl-N is pressed
let g:asyncomplete_auto_completeopt = 0         " Set completeopt such that it opens a menu, selects the first option, but doesn't automatically insert
set completeopt=menuone,noinsert

"set switchbuf+=usetab,newtab    " Open a file in existing tab if already open, otherwise new tab


"""""""""""
" Colours "
"""""""""""

function! ApplyCustomColors()
    " If the Pmenu background is Magenta, then change it to a more visible color
    let output = execute('highlight Pmenu')
    if output =~ '.*Magenta.*'
        highlight Pmenu ctermbg=darkblue guibg=darkblue
    endif
    highlight Error guibg=NONE
endfunction


" Switch syntax highlighting on, when the terminal has colors or the gui is running
if &t_Co > 2 || has("gui_running")
    syntax on
    syntax sync fromstart

    let g:allcolors = map(split(globpath(&runtimepath . ",/usr/share/vim-scripts/color_sampler_pack/", 'colors/*.vim'), "\n"), 'fnamemodify(v:val, ":t:r")')
    let g:allairline = map(split(globpath(&runtimepath, 'bundle/vim-airline-themes/autoload/airline/themes/*.vim'), "\n"), 'fnamemodify(v:val, ":t:r")')

    let g:favcolors = [ 'badwolf', 'darkblue', 'desert', 'elflord', 'evening', 'flattown', 'gentooish', 'gotham', 'greenvision', 'industry', 'jellyx', 'koehler', 'leo', 'lettuce', 'lodestone', 'murphy', 'pablo', 'ron', 'slate', 'Sunburst', 'torte', 'vividchalk', 'mustang', 'anokha', 'anotherdark', 'astroboy', 'asu1dark', 'autumnleaf', 'bigbang', 'blacksea', 'bluegreen', 'breeze', 'brookstream', 'calmar256-dark', 'candy', 'candycode', 'clarity', 'colorer', 'dante', 'darkZ', 'darkblue2', 'darkbone', 'darkburn', 'darkslategray', 'darkspectrum', 'dejavu', 'desert256', 'desertEx', 'dusk', 'dw_blue', 'dw_green', 'dw_orange', 'dw_purple', 'dw_red', 'dw_yellow', 'earendel', 'ekvoli', 'fnaqevan', 'freya', 'fruity', 'fu', 'golden', 'guardian', 'herald', 'inkpot', 'jammy', 'jellybeans', 'kellys', 'liquidcarbon', 'manuscript', 'marklar', 'maroloccio', 'masmed', 'matrix', 'metacosm', 'midnight2', 'molokai', 'moss', 'motus', 'navajo-night', 'neon', 'neverness', 'night', 'night_vision', 'nightshimmer', 'no_quarter', 'northland', 'oceanblack', 'oceandeep', 'railscasts', 'rdark', 'relaxedgreen', 'rootwater', 'sea', 'settlemyer', 'softblue', 'sorcerer', 'synic', 'tabula', 'tango', 'tango2', 'tesla', 'tir_black', 'twilight', 'two2tango', 'vibrantink', 'vimhut', 'wombat', 'wuye', 'xoria256', 'zenburn', 'zendnb', 'zmrok' ]
    let g:colors = g:favcolors
    let g:colors_last = 0

    function! RandomColor()
        let g:colors_last = system('echo $RANDOM') % len(g:colors)
        execute 'colorscheme ' . get(g:colors, g:colors_last)
        call ApplyCustomColors()
    endfunction
    command Random call RandomColor()
    nmap <C-C><C-R> :Ra<CR>

    function! ColorNext()
        let g:colors_last = (g:colors_last + 1) % len(g:colors)
        execute 'colorscheme ' . get(g:colors, g:colors_last)
        call ApplyCustomColors()
    endfunction
    command NC call ColorNext()
    nmap <C-C><C-N> :NC<CR>

    function! ColorPrev()
        let g:colors_last = (g:colors_last - 1) % len(g:colors)
        execute 'colorscheme ' . get(g:colors, g:colors_last)
        call ApplyCustomColors()
    endfunction
    command PC call ColorPrev()
    nmap <C-C><C-P> :PC<CR>

    function! RandomAirline()
        let g:airline_theme = get(g:allairline, system('echo $RANDOM') % len(g:allairline))
    endfunction
    command RA call RandomAirline()
    nmap <C-C><C-S> :RA<CR>

    call RandomColor()
    "let g:airline_theme = 'badwolf'
    call RandomAirline()
    nmap <C-C><C-S> :AirlineTheme random<CR>
endif

"""""""""""""
" Functions "
"""""""""""""

function! ToggleLineLength()
    " Highlight lines that are too long
    hi LineOverflow  ctermfg=white ctermbg=red guifg=white guibg=#FF2270
    if !exists('w:m1')
        let w:m1=matchadd('LineOverflow','\%>120v.\+', -1)
    else
        call matchdelete(w:m1)
        unlet w:m1
    endif
endfunction
command TLL call ToggleLineLength()


function! ToggleTrailingSpace()
    " Highlight trailing spaces
    hi TrailingSpaces  ctermfg=white ctermbg=red guifg=white guibg=#FF2270
    if !exists('w:m2')
        let w:m2=matchadd('TrailingSpaces','\s\+$', -1)
    else
        call matchdelete(w:m2)
        unlet w:m2
    endif
endfunction
command TTS call ToggleTrailingSpace()


""""""""""""""""
" Key Bindings "
""""""""""""""""

" Horizontal Scrolling
map <C-ScrollWheelDown> 20zl
map <C-ScrollWheelUp> 20zh
" Right
map <S-Right> 40zl
vmap <S-Right> 40zl
imap <S-Right> <C-O>40zl
" Left
map <S-Left> 40zh
vmap <S-Left> 40zh
imap <S-Left> <C-O>40zh

" Set Copy/Cut/Paste keys depending on if the clipboard is present
if has('clipboard')
    " Copy
    vnoremap <C-C> "+y
    vnoremap <C-Insert> "+y

    " Cut
    vnoremap <C-X> "+x
    vnoremap <S-Del> "+x

    " Paste
    map <C-V> "+gP
    cmap <C-V> <C-R>+
    imap <C-V> <C-R>+
else
    " If the X clipboard is not present, then the + register wont exist, so use the z register instead

    " Copy
    vnoremap <C-C> "zy
    vnoremap <C-Insert> "zy

    " Cut
    vnoremap <C-X> "zx
    vnoremap <S-Del> "zx

    " Paste
    map <C-V> "zgP
    cmap <C-V> <C-R>z
    imap <C-V> <C-R>z
endif

" Remap Visual Block command (which was CTRL-V)
noremap ; <C-V>
noremap <C-Q> <C-V>
command! Vb normal! <C-V>

" Use CTRL-S for saving
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w

" Maximize Current Window
map <C-W><C-M> <C-W>_

" // in Visual mode will search for selected text
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>


"""""""""""""""""""""""""
" User-Defined Commands "
"""""""""""""""""""""""""

" Use 4 character tabs instead of 8 (\t* + 4 spaces)
command SmartTabs set ts=8 sw=4 sts=4 smarttab
command ST SmartTabs

" Use 4 character tabs instead of 8 but expand all tabs to spaces
command PythonTabs set ts=8 sw=4 sts=4 smarttab expandtab
command PT PythonTabs

" Use 2 character tabs instead of 8 but expand all tabs to spaces
command WebTabs set ts=8 sw=2 sts=2 smarttab expandtab
command WT WebTabs

" Reset to tabs with a tabstop of 8
command ResetTabs set ts=8 sw=8 sts=0 noexpandtab nosmarttab
command RT ResetTabs

" Enable word wrap
command SetWrap set wrap linebreak
command SW SetWrap

" Change to current file's directory
command CH cd %:p:h
command LCH lcd %:p:h

" Enable word wrap
command FixSync syntax sync fromstart
command FS FixSync


""""""""""""""""""""""""
" Filetype Adjustments "
""""""""""""""""""""""""

" For arduino *.ino files, treat as a C++ file
autocmd BufRead,BufNewFile *.ino setfiletype cpp

" For *.py files, set the tabstop to 4 and expand tabs to space
autocmd BufRead,BufNewFile *.py PythonTabs

" For *.js files, set the tabstop to 4 and expand tabs to space
autocmd BufRead,BufNewFile *.js PythonTabs

" For *.pyhtml files, treat as a HTML file
autocmd BufRead,BufNewFile *.pyhtml set syntax=aspperl

" For *.md and *.txt files, enable spell check
autocmd BufRead,BufNewFile *.md set spell
"autocmd BufRead,BufNewFile *.txt set spell


"""""""""""""""""
" Miscellaneous "
"""""""""""""""""

" Sleuth disable auto indent
let g:did_indent_on = 0


" Enable Powerline fonts in airline
"set rtp+=/usr/local/lib/python3.7/dist-packages/powerline/bindings/vim/
"let g:airline_powerline_fonts=1


"Setup rust-analyzer
if executable('rust-analyzer')
  au User lsp_setup call lsp#register_server({
        \   'name': 'Rust Language Server',
        \   'cmd': {server_info->['rust-analyzer']},
        \   'whitelist': ['rust'],
        \ })
  "set signcolumn=yes
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

command D LspDocumentDiagnostics

if !empty(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif
