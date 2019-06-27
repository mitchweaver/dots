" http://github.com/mitchweaver/dots

" unbind space for everything but leader
nnoremap <silent><SPACE> <nop>
let mapleader=" "
"  --------------- Plugins ------------------------------
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    set nocompatible
    filetype off
    call plug#begin('~/.vim/vim-plug')

    Plug 'vimwiki/vimwiki' " the ultimate note taking system
    Plug 'godlygeek/tabular' " tab alignment
    Plug 'tpope/vim-commentary' " comment toggler
    Plug 'ervandew/supertab' " code completion
    Plug 'tpope/vim-surround' " quote/paren etc surrounding
    Plug 'terryma/vim-multiple-cursors' " sublime-like multiple select
    Plug 'airblade/vim-gitgutter' " git diffing along the left side
    Plug 'tpope/vim-repeat' " allows '.' for more things
    Plug 'dylanaraps/wal.vim' " pywal theme
    Plug 'sheerun/vim-polyglot' " syntax highlighting
    
    call plug#end()
    filetype indent plugin on
    syntax enable
    map <silent><leader>pi :PlugInstall<CR>
    map <silent><leader>pu :PlugUpdate<CR>
    map <silent><leader>pc :PlugClean<CR>

colorscheme wal
endif
" --------------------------------------------------------

set background=dark
" set background=light

set backspace=indent,eol,start " make backspace useable
set whichwrap+=<,>,h,l " wrap around lines with these keys
set updatetime=750 " time until bg calls after typing
set timeout! " Disable keybind timeout
set ttimeout! " Disable keybind timeout
set clipboard=unnamed " yank/paste to/from system clipboard
set vb " disable audible bell
set novisualbell " kill the visual bell too
set noerrorbells " did I mention I hate bells?
set lazyredraw " whether to redraw screen after macros
set mat=2 " how fast to blink matched brackets
set textwidth=0 " very annoying warning
set backspace=2 " allow backspace to go over new lines

set shellslash
set wildmenu " makes shell completion a bit better
set wildmode=longest,list,full
set ffs=unix

set history=500
set undolevels=500
set undoreload=1000

set title " keep window name updated with current file
set noruler " don't show file position in the bottom right
set noshowmode " don't show 'insert' or etc on bottom left
set laststatus=0 " Disable bottom status line / statusbar
set noshowcmd " don't print the last run command
set mousehide " hide the mouse while typing
set ch=1 " get rid of the wasted line at the bottom

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
set hid " hide buffer when closed
set scrolloff=8 " pad X lines when scrolling
set fillchars=""  " extremely annoying
set diffopt+=iwhite " disable white space diffing
set formatoptions+=o " continue comments new lines
set synmaxcol=512
set nowrap
set encoding=utf-8

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab " use spaces instead of tabs.
set smarttab " soft tab creation / deletion
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " match indents on new lines.
set smartindent

set nobackup " we have vcs, we don't need backups.
set nowritebackup " we have vcs, we don't need backups.
set noswapfile " annoying
set hidden " allow buffers with unsaved changes
set autoread " reload files if changed on disk

nnoremap <Leader>b :b 

set tabpagemax=10 " dont show more than 10 tabs
map <silent>th  :tabfirst<CR>
map <silent>tk  :tabnext<CR>
map <silent>tj  :tabprev<CR>
map <silent>tl  :tablast<CR>

map <silent>tt     :tabedit<Space>
map <silent>tn     :tabnew<CR>
map <silent>td     :tabclose<CR>
map tm             :tabm<Space>

nmap <silent><C-k> :wincmd k<CR>
nmap <silent><C-j> :wincmd j<CR>
nmap <silent><C-h> :wincmd h<CR>
nmap <silent><C-l> :wincmd l<CR>

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

if has('nvim')
    nnoremap ci: T:ct:
    nnoremap ci. T.ct.
    nnoremap ci, T,ct,
    nnoremap ci< T<ct>
    nnoremap ci> T<ct>
endif

" -------------- Extension Settings ----------------------
if exists(':PlugInstall')
    let g:gitgutter_map_keys = 0 " disable all gitgutter keybinds
    let g:gitgutter_realtime = 0 " only run gitgutter on save

    map <silent><leader>g :GitGutterToggle<CR>

    let g:multi_cursor_use_default_mapping=0
    let g:multi_cursor_next_key='<c-m>'
    let g:multi_cursor_prev_key='<c-p>'
    let g:multi_cursor_skip_key='<c-x>'
    let g:multi_cursor_quit_key='<esc>'

    nmap <silent><leader>c :Commentary<CR>
    autocmd FileType asm setlocal commentstring=;\ %s
    autocmd FileType conf setlocal commentstring=#\ %s
    autocmd FileType rc setlocal commentstring=#\ %s
    autocmd FileType *Pkgfile set filetype=sh

    let wiki = {}
    let g:vimwikidir = "/home/mitch/var/files/vimwiki"
    let wiki.path = g:vimwikidir
    let g:vimwiki_list=[wiki]
    let g:vimwiki_hl_headers = 1
    let g:vimwiki_hl_cb_checked = 1
    let g:vimwiki_list = [
        \{'path': '~/var/files/vimwiki/personal.wiki',    'syntax': 'markdown', 'ext': '.md'},
    \]
    let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

    let g:asmsyntax = 'nasm'

    nnoremap <silent><leader>wg :VimwikiDiaryGenerateLinks<CR>
endif

set wildignore+=*.opus,*.flac,*.pdf,*.jpg,*.png,*.so,*.swp,*.zip,*.gzip,*.bz2,*.tar,*.xz,*.lrzip,*.lrz,*.mp3,*.ogg,*.mp4,*.gif,*.jpeg,*.webm

map <F9>  :setlocal spell! spelllang=en_gb<CR>
map <F10> :setlocal spell! spelllang=de_de<CR>

" Horizontal scrolling
noremap <silent><C-o> 10zl
noremap <silent><C-i> 10zh

" swap f/b
noremap <silent><C-f> <C-b>
noremap <silent><C-b> <C-f>

" Nuke +, -, ! at start of lines in diffs (also killing the - lines)
map <silent> <C-z> :%s/^+<CR> :%s/^-.*<CR> :%s/^!<CR>

map <silent><leader>w :w<CR>
map <silent><leader>q :q<CR>

" print a 60-char line separator
inoremap <silent><C-s> ------------------------------------------------------- <ESC>:Commentary<CR>0llllllllllllllllllllli

cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))

augroup resCur "reopen vim at previous cursor point
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

" conflicts with st
map  <silent><c-=>    <nop>
map  <silent><c-->    <nop>
" conflicts with tabbed
" map <silent><C-h>     <nop>
" map <silent><C-l>     <nop>
" map <silent><C-n>    <nop>
map <silent><C-w>    <nop>

map <leader>md :!/home/mitch/usr/bin/previewmarkdown.sh -i "%" -b $BROWSER<CR>

" ----------- Open files in ranger ----------------------- 
if has('nvim')
    function! s:RangerOpenDir(...)
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
        autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | call s:RangerOpenDir(argv()[0]) | endif
    augroup END

    command! -complete=dir -nargs=* Ranger :call <SID>RangerOpenDir(<f-args>)
    nnoremap <silent><leader>r :Ranger<CR>
endif
" ------------------------------------------------------- 

if has('nvim')
    " pause :terminal emulation
    tnoremap <silent><C-z> <C-\><C-n>
endif
