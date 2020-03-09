" Neovim config file                  "
"  ⡀⢀ ⠄ ⣀⣀  ⡀⣀ ⢀⣀                     "
"  ⠱⠃ ⠇ ⠇⠇⠇ ⠏  ⠣⠤                     "
"                                     "
" http://github.com/mitchweaver/dots  "
"                                     "
"'"'"'"'"'"'"'"'"'"'"'"'"'"'"'"'"'"'"'"
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" unbind space for everything but leader
nnoremap <silent><SPACE> <nop>
let mapleader=" "

" -*-*-*-*-*-*-*-* Plugins *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set nocompatible
filetype off
call plug#begin('~/.vim/vim-plug')

Plug 'vimwiki/vimwiki' " the ultimate note taking system
Plug 'ap/vim-buftabline' " display buffers along top as tabs
Plug 'tpope/vim-commentary' " comment toggler
Plug 'godlygeek/tabular' " tab alignment
Plug 'ervandew/supertab' " code completion
Plug 'terryma/vim-multiple-cursors' " sublime-like multiple select
Plug 'airblade/vim-gitgutter' " git diffing along the left side
Plug 'tpope/vim-surround' " surround stuff with stuff
Plug 'dylanaraps/wal.vim' " pywal theme
Plug 'tpope/vim-repeat' " allows '.' to do more things
" Plug 'sheerun/vim-polyglot' " syntax highlighting

call plug#end()
filetype indent plugin on

map <silent><leader>pi :PlugInstall<CR>
map <silent><leader>pu :PlugUpdate<CR>
map <silent><leader>pc :PlugClean<CR>
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

" -*-*-*-*-*- general -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
scriptencoding utf-8
set encoding=utf-8
set history=200
set backspace=indent,eol,start " make backspace useable
set whichwrap+=<,>,h,l " wrap around lines with these keys
set updatetime=750 " time until bg calls after typing
set timeout! " Disable keybind timeout
set ttimeout! " Disable keybind timeout
set clipboard=unnamed " yank/paste to/from system clipboard
"set clipboard=unnamedplus " yank/paste to/from system clipboard
set lazyredraw " whether to redraw screen after macros
set mat=2 " how fast to blink matched brackets
set textwidth=0 " very annoying warning
set backspace=2 " allow backspace to go over new lines
set title " keep window name updated with current file
set noruler " don't show file position in the bottom right
set noshowmode " don't show 'insert' or etc on bottom left
set laststatus=0 " Disable bottom status line / statusbar
set noshowcmd " don't print the last run command
set ch=1 " get rid of the wasted line at the bottom
set cmdheight=1 " cmd output only take up 1 line
set nostartofline " gg/G do not always go to line start
set modeline " enable per-file custom syntax
noremap ; :

" automatic linebreak
" set lbr
" set tw=100
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

" ----- colors -------------------- 
" set background=dark
set background=light
colorscheme wal
"  --------------------------------

" ---- syntax stuff -------------
autocmd BufNewFile,BufRead *.config set syntax=sh
autocmd BufNewFile,BufRead *.conf set syntax=sh
autocmd BufNewFile,BufRead *.cfg set syntax=sh
autocmd BufNewFile,BufRead *.rc set syntax=sh
autocmd BufNewFile,BufRead pkgfile set syntax=sh

autocmd BufNewFile,BufRead *.c set syntax=c
autocmd BufNewFile,BufRead *.patch set syntax=c
autocmd BufNewFile,BufRead *.hs set syntax=haskell
autocmd BufNewFile,BufRead *.py set syntax=python
autocmd BufNewFile,BufRead *.pl set syntax=perl
autocmd BufNewFile,BufRead *.txt set syntax=off
autocmd BufNewFile,BufRead *.md set syntax=md
autocmd BufNewFile,BufRead *.pad set syntax=md
let g:is_posix = 1
let g:asmsyntax = 'nasm'
autocmd BufRead *.rc setlocal ft=sh
autocmd BufRead *.asm setlocal ft=nasm
map <silent><leader>sy :set syntax=sh<cr>
" syntax off
" -------------------------------

" set number relativenumber
map <silent><leader>ln :set number! relativenumber!<cr>

let s:color_column_old = 80
function! s:ToggleColorColumn()
    if s:color_column_old == 0
        let s:color_column_old = &colorcolumn
        set colorcolumn=0
    else
        let &colorcolumn=s:color_column_old
        let s:color_column_old = 0
    endif
endfunction
nnoremap <silent><leader>ll :call <SID>ToggleColorColumn()<cr>

set showmatch " show matching parens
set scrolloff=8 " pad X lines when scrolling
set fillchars=""  " extremely annoying
set diffopt+=iwhite " disable white space diffing
set formatoptions+=o " continue comments new lines
set synmaxcol=512
set nowrap
set encoding=utf-8

" --- tabs ----------
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab " use spaces instead of tabs.
set smarttab " soft tab creation / deletion
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " match indents on new lines.
set smartindent
" --------------------

" ---- annoying nonsense ------------------
set vb " disable audible bell
set novisualbell " kill the visual bell too
set noerrorbells " did I mention I hate bells?
set nobackup " we have vcs, we don't need backups.
set nowritebackup " we have vcs, we don't need backups.
set noswapfile " annoying
" -----------------------------------------

" -------- buffers ------------------------------
set hidden " allow buffers with unsaved changes
set autoread " reload files if changed on disk

" b <num> = go to $buffer
nnoremap <Leader>b :b 

map <silent><C-k> :bnext<CR>
map <silent><C-j> :bprev<CR>
map <silent><C-d> :bd<cr>
map <silent>tk :bnext<CR>
map <silent>tj :bprev<CR>
map <silent>td :bd<cr>
" -------------------------------------------------

" make < and > retain selection
vnoremap < <gv
vnoremap > >gv

map Q @q

set ignorecase " case insensitive search
set smartcase " if there are uppercase letters, become case-sensitive.
set incsearch " live incremental searching
set showmatch " live match highlighting
set hlsearch " highlight matches
set gdefault " use the `g` flag by default.
set wrapscan " searching wraps lines
set magic " 'magic' patterns - (extended regex)
nnoremap <silent><leader><leader> :let @/ = ""<CR>:noh<CR>

" Search and Replace
nmap <Leader>s :%s//g<Left><Left>

" -------------- Extension Settings ----------------------
if exists(':PlugInstall')
    let g:gitgutter_map_keys = 0 " disable all gitgutter keybinds
    let g:gitgutter_realtime = 0 " only run gitgutter on save
    set signcolumn=auto " (mostly for gitgutter): yes=always, no=never, auto=ifchanges

    map <silent><leader>g :GitGutterToggle<CR>
    nmap ]h <Plug>GitGutterNextHunk
    nmap [h <Plug>GitGutterPrevHunk
    nmap <Leader>hs <Plug>GitGutterStageHunk
    nmap <Leader>hr <Plug>GitGutterUndoHunk

    let g:multi_cursor_use_default_mapping=0
    let g:multi_cursor_next_key='<c-m>'
    let g:multi_cursor_prev_key='<c-p>'
    let g:multi_cursor_skip_key='<c-x>'
    let g:multi_cursor_quit_key='<esc>'

    nmap <silent><leader>c :Commentary<CR>
    autocmd FileType asm setlocal commentstring=;\ %s
    autocmd FileType conf setlocal commentstring=#\ %s
    autocmd FileType rc setlocal commentstring=#\ %s
    autocmd BufNewFile,BufRead pkgfile setlocal commentstring=#\ %s

    let wiki = {}
    let g:vimwikidir = "$XDG_DOCUMENTS_DIR/vimwiki"
    let wiki.path = g:vimwikidir
    let g:vimwiki_list=[wiki]
    let g:vimwiki_list = [
        \{'path': '$XDG_DOCUMENTS_DIR/vimwiki/personal.wiki',    'syntax': 'markdown', 'ext': '.md'},
    \]
    let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

    " vim surround -- becuase nobody uses 's' anyway
	nmap ss ysiw
	nmap sl yss
	vmap s S

    let g:buftabline_show = 1

    " fff
"    nnoremap <silent><leader>r :F<CR>
    " ranger
    let g:ranger_map_keys = 0
    nnoremap <silent><leader>r :Ranger<CR>
endif

set wildignore+=*.opus,*.flac,*.pdf,*.jpg,*.png,*.so,*.swp,*.zip,*.gzip,*.bz2,*.tar,*.xz,*.lrzip,*.lrz,*.mp3,*.ogg,*.mp4,*.gif,*.jpeg,*.webm

" Horizontal scrolling
noremap <silent><C-o> 10zl
noremap <silent><C-i> 10zh

" swap f/b -- i know, i'm a madman.
noremap <silent><C-f> <C-b>
noremap <silent><C-b> <C-f>

" Nuke +, -, ! at start of lines in diffs (also killing the - lines)
" map <silent> <C-z> :%s/^+<CR> :%s/^-.*<CR> :%s/^!<CR>

" remap WQ to :w :q
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
map <silent><leader>w :w<CR>
map <silent><leader>q :q<CR>

" print a 60-char line separator, commented
map <C-s> 30i-*<ESC>:Commentary<CR>

" conflicts with st/tabbed:
map  <silent><c-=> <nop>
map  <silent><c--> <nop>
map  <silent><C-w> <nop>

" map <leader>md :MarkdownPreview<CR>

augroup resCur "reopen vim at previous cursor point
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

" ----------- Open files in ranger ----------------------- 
if has('nvim')
    function! s:Ranger(...)
        let path = a:0 ? a:1 : getcwd()

        if !isdirectory(path)
            echom 'Not a directory: ' . path
            return
        endif

        let s:ranger_tempfile = tempname()
        let opts = ' --cmd="set viewmode multipane"'
        let opts .= ' --choosefiles=' . shellescape(s:ranger_tempfile)
        if a:0 > 1
            let opts .= ' --selectfile='. shellescape(a:2)
        else
            let opts .= ' ' . shellescape(path)
        endif
        let rangerCallback = {}

        function! rangerCallback.on_exit(id, code, _event)
            " Open previous buffer or new buffer *before* deleting the terminal
            " buffer. This ensures that splits don't break if ranger is opened in
            " a split window.
            if w:_ranger_del_buf != w:_ranger_prev_buf
                " Restore previous buffer
                exec 'silent! buffer! '. w:_ranger_prev_buf
            else
                " Previous buffer was empty
                enew
            endif

            " Delete terminal buffer
            exec 'silent! bdelete! ' . w:_ranger_del_buf

            unlet! w:_ranger_prev_buf w:_ranger_del_buf

            let names = ''
            if filereadable(s:ranger_tempfile)
                let names = readfile(s:ranger_tempfile)
            endif
            if empty(names)
                return
            endif
            for name in names
                exec 'edit ' . fnameescape(name)
                doautocmd BufRead
            endfor
        endfunction

        " Store previous buffer number and the terminal buffer number
        let w:_ranger_prev_buf = bufnr('%')
        enew
        let w:_ranger_del_buf = bufnr('%')

        " Open ranger in nvim terminal
        call termopen('ranger ' . opts, rangerCallback)
        startinsert
    endfunction

    let g:loaded_netrwPlugin = 'disable'
    augroup ReplaceNetrwWithRanger
        autocmd StdinReadPre * let s:std_in = 1
        autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | call s:Ranger(argv()[0]) | endif
    augroup END

    command! -complete=dir -nargs=* Ranger :call <SID>Ranger(<f-args>)
endif
" -------------------------------------------------------
