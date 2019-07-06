
" Activate the vim package manager, pathogen
execute pathogen#infect()

set encoding=utf-8

set ff=unix
set nowrap
set nocompatible
behave xterm

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

"set backup		" keep a backup file
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set number              " show line numbers

" Enable persistent undo so that undo history persists across vim sessions
set undofile
set undodir=~/.vim/undo

"set ignorecase
"set smartcase          " if search is lowercase, ignorecase, otherwise case-sensitive

"set switchbuf+=usetab,newtab    " Open a file in existing tab if already open, otherwise new tab


" Switch syntax highlighting on, when the terminal has colors or the gui is running
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch			" highlight search terms
    syntax sync fromstart

    "color morning
    "color pablo
    "color lodestone

    let g:colors = [ 'badwolf', 'darkblue', 'desert', 'elflord', 'evening', 'flattown', 'gentooish', 'gotham', 'greenvision', 'industry', 'jellyx', 'koehler', 'leo', 'lettuce', 'lodestone', 'murphy', 'pablo', 'ron', 'slate', 'Sunburst', 'torte', 'vividchalk' ]
    let g:colors_last = 0

    function! RandomColor()
        let g:colors_last = system('echo $RANDOM') % len(g:colors)
        execute 'colorscheme ' . get(g:colors, g:colors_last)
    endfunction
    command Random call RandomColor()

    function! ColorNext()
        let g:colors_last = (g:colors_last + 1) % len(g:colors)
        execute 'colorscheme ' . get(g:colors, g:colors_last)
    endfunction
    command NC call ColorNext()
    nmap <C-C><C-N> :NC<CR>

    function! ColorPrev()
        let g:colors_last = (g:colors_last - 1) % len(g:colors)
        execute 'colorscheme ' . get(g:colors, g:colors_last)
    endfunction
    command PC call ColorPrev()
    nmap <C-C><C-P> :PC<CR>

    call RandomColor()
    let g:airline_theme = 'badwolf'
endif



""""""""""""""""
" Key Bindings "
""""""""""""""""

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-V and SHIFT-Insert are Paste
map <C-V> "+gP
cmap <C-V> <C-R>+
imap <C-V> <C-R>+

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q> <C-V>

" Use CTRL-S for saving, also in Insert mode
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

" Fix syntax highlighting
autocmd BufEnter * :syntax sync fromstart


function! EnableSyntastic()
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 1
    let g:syntastic_enable_highlighting = 1
    let g:syntastic_enable_signs = 1
    let g:syntastic_javascript_checkers = ['eslint']
    let g:syntastic_javascript_eslint_exe = 'eslint'
endfunction
command ES call EnableSyntastic()


function! EnableLineLength()
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


" Highlight lines that are too long
"augroup highlight
"  autocmd!
"  " Highlight lines longer than 120 chars
"  autocmd BufEnter,VimEnter,FileType *.rb,*.coffee,*.js,*.jsx,*.ex,*.exs,*.elm
"      \ if !exists('w:m1') | let w:m1=matchadd('LineOverflow','\%>120v.\+', -1) | endif
"  " Highlight trailing spaces
"  autocmd BufEnter,VimEnter,FileType *.rb,*.coffee,*.js,*.jsx,*.ex,*.exs,*.elm
"      \ if !exists('w:m2') | let w:m2=matchadd('TrailingSpaces','\s\+$', -1) | endif
"augroup END
