" https://github.com/MitchWeaver/dotfiles/vimrc
"
"         ________ ++     ________
"       /VVVVVVVV\++++  /VVVVVVVV\
"       \VVVVVVVV/++++++\VVVVVVVV/
"        |VVVVVV|++++++++/VVVVV/'
"        |VVVVVV|++++++/VVVVV/'
"       +|VVVVVV|++++/VVVVV/'+
"     +++|VVVVVV|++/VVVVV/'+++++
"   +++++|VVVVVV|/VVV___++++++++++
"     +++|VVVVVVVVVV/##/ +_+_+_+_
"       +|VVVVVVVVV___ +/#_#,#_#,\
"        |VVVVVVV//##/+/#/+/#/'/#/
"        |VVVVV/'+/#/+/#/+/#/ /#/
"        |VVV/'++/#/+/#/ /#/ /#/
"        'V/'  /##//##//##//###/
"                ++

" unbind space for everything but leader
nnoremap <silent><SPACE> <nop>
let mapleader=" "
"  --------------- Plugins ------------------------------ "
set nocompatible
filetype off
call plug#begin('~/.vim/vim-plug')

Plug 'vimwiki/vimwiki' " the ultimate note taking system
Plug 'dylanaraps/wal.vim' " pywal theme
Plug 'lilydjwg/colorizer' " colorizes rgb hex codes
Plug 'ervandew/supertab' " code completion
Plug 'tpope/vim-commentary' " comment toggler
Plug 'terryma/vim-multiple-cursors' " sublime-like multiple select
Plug 'tpope/vim-surround' " quote/paren etc surrounding
Plug 'airblade/vim-gitgutter' " git diffing along the left side
Plug 'godlygeek/tabular' " tab alignment

call plug#end()
filetype indent plugin on
syntax enable
map <silent><leader>pi :PlugInstall<CR>
map <silent><leader>pu :PlugUpdate<CR>
map <silent><leader>pc :PlugClean<CR>
" ------------------------------------------------------- "

" ------------- COLORSCHEME ------------------------------------
colorscheme wal
set background=dark
" set background=light
" ---------------------------------------------------------------

" -------------- Vim Specific Configs -------------------------
" set mouse=n " NOTE THIS BREAKS MIDDLE CLICK PASTE on some terminals
set backspace=indent,eol,start " make backspace useable
set whichwrap+=<,>,h,l " wrap around lines with these keys
set updatetime=750 " how long til vim does background calls after typing
set timeout! " Disable keybind timeout
set ttimeout! " Disable keybind timeout
set clipboard=unnamed " yank/paste to/from system clipboard
set vb " disable audible bell
set novisualbell " kill the visual bell too
set noerrorbells " did I mention I hate bells?
set lazyredraw " whether to redraw screen after macros
set mat=2 " how fast to blink matched brackets
set textwidth=0 " very annoying warning occurs with long lines
set backspace=2 " allow backspace to go over new lines, etc
set ttimeoutlen=100 " timeout between key presses for cmds
" -------------------------------------------------------------

" ---------------- OS Specific Configs ------------------------
set shellslash
" set shell=mksh
" set shell=ksh
set wildmenu " makes shell completion a bit better
set wildmode=longest,list,full
set ffs=unix
" -------------------------------------------------------------

" ------------ HISTORY ---------------------------------------
set history=500
set undolevels=500
set undoreload=1000
" -----------------------------------------------------------

" ---------- UI ---------------------------------------------
" highlight trailing whitespace - (annoying imo)
" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" match ExtraWhitespace /\s\+$\|\t/
set title " keep window name updated with current file

set formatoptions+=o " continue comment marker on new lines

set noruler " don't show file position in the bottom right
set noshowmode " don't show 'insert' or 'normal' etc on bottom left
set laststatus=0 " Disable bottom status line / statusbar
set noshowcmd " don't print the last run command
set mousehide " hide the mouse while typing
set ch=1 " command height --- get rid of the wasted line at the bottom

" ~~~ I prefer these two disabled at startup, see function below
" set number " enables line numbers on startup
" set relativenumber " shows line numbers relative to position

" Toggle line numbering on/off
map <silent><leader>ln :set number! relativenumber!<cr>

" ~~~ Again, I prefer this disabled at startup
"     with a toggle below.
" set colorcolumn=80

" Toggle color column on/off
let s:color_column_old = 60
function! s:ToggleColorColumn()
    if s:color_column_old == 0
        let s:color_column_old = &colorcolumn
        "windo let &colorcolumn = 0
        set colorcolumn=0
    else
        "windo let &colorcolumn=s:color_column_old
        let &colorcolumn=s:color_column_old
        let s:color_column_old = 0
    endif
endfunction
nnoremap <silent><leader>ll :call <SID>ToggleColorColumn()<cr>

set showmatch " show matching parens

set hid " hide buffer when closed

" set cursorline " WARNING - this is *very* slow

set scrolloff=10 " keep cursor X lines from the top/bottom when scrolling

set fillchars=""  " extremely annoying, they serve no purpose

" don't syntax highlight lines that are too long (slow)
set synmaxcol=512
" ------------------------------------------------------------

" ------ FORMATTING -----------------------------------------
set nowrap " dont wrap lines
set encoding=utf-8
set diffopt+=iwhite " disable white space diffing
" --------------------------------------------------------------

" -------- Tabs and Spacing -----------------------------------
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab " use spaces instead of tabs.
set smarttab " let's tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " match indents on new lines.
set smartindent " intellegently dedent / indent new lines based on rules
" --------------------------------------------------------------

" ---------- File Management -------------------------------------
set nobackup " we have vcs, we don't need backups.
set nowritebackup " we have vcs, we don't need backups.
set noswapfile " they're just annoying. who likes them?
set hidden " allow me to have buffers with unsaved changes.
set autoread " when a file has changed on disk, just load it. don't ask.
" -------------------------------------------------------------

" -------- Tabs ----------------------------------------------
set tabpagemax=10 " dont show more than 10 tabs
map <silent><C-h>  :tabfirst<CR>
map <silent><C-k>  :tabnext<CR>
map <silent><C-j>  :tabprev<CR>
map <silent><C-l>  :tablast<CR>

map <silent>tt     :tabedit<Space>
map <silent>tn     :tabnew<CR>
map <silent>tm     :tabm<Space>
map <silent>td     :tabclose<CR>
" ------------------------------------------------------------

" ---------- Movement -------------------------------------------
"  scroll up/down without moving the cursor position
nnoremap <silent><C-e> <C-e>
nnoremap <silent><C-w> <C-y>
map <silent><C-y> <nop>
" -----------------------------------------------------------------

" ---------- Searching ----------------------------------------
set ignorecase " case insensitive search
set smartcase " if there are uppercase letters, become case-sensitive.
set incsearch " live incremental searching
set showmatch " live match highlighting
set hlsearch " highlight matches
set gdefault " use the `g` flag by default.
set wrapscan " searching wraps lines
set magic " 'magic' patterns - (extended regex)
" Clear the highlighted search -- note: does not disable, only clears.
nnoremap <silent><leader><leader> :let @/ = ""<CR>

" Search and Replace
nmap <Leader>s :%s//g<Left><Left>
" -------------------------------------------------------------

" -------- Language Syntax Management ---------------------------
iab #i #include <.h>
let g:is_bash=1 " vim's default sh syntax highlighting is horrible
" --------------------------------------------------------------

" -------------- Extension Settings --------------------------
" disable all gitgutter keybinds
let g:gitgutter_map_keys = 0
" only run gitgutter on save
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

" toggle gitgutter
map <silent><leader>g :GitGutterToggle<CR>

let g:multi_cursor_use_default_mapping=0
" i use 'm' here because c-n is reserved for `tabbed`
let g:multi_cursor_next_key='<c-m>'
let g:multi_cursor_prev_key='<c-p>'
let g:multi_cursor_skip_key='<c-x>'
let g:multi_cursor_quit_key='<esc>'

" map the key for toggling comments with vim-commentary
nmap <silent><leader>c :Commentary<CR>
autocmd FileType asm setlocal commentstring=;\ %s
autocmd FileType conf setlocal commentstring=#\ %s

" ------------ Vim Wiki ---------------------------------------
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

set wildignore+=*.opus,*.flac,*.pdf,*.jpg,*.png,*.so,*.swp,*.zip,*.gzip,*.bz2,*.tar,*.xz,*.lrzip,*.lrz,*.mp3,*.ogg,*.mp4,*.gif,*.jpeg,*.webm
" open given vimwiki index: <leader>ws
" open vimwiki diary: <leader>w<leader>w
" open vimwiki diary index page: <leader>wi
nnoremap <silent><leader>wg :VimwikiDiaryGenerateLinks<CR>
" --------------------------------------------------------------

" ------------------ Vim Surround ------------------------ "
" # todo:
" -------------------------------------------------------- "

" ------ misc keybinds ------------------------------------------
map <F9>  :setlocal spell! spelllang=en_gb<CR>
map <F10> :setlocal spell! spelllang=de_de<CR>

" Horizontal scrolling
map <silent> <C-o> 10zl
map <silent> <C-i> 10zh

" Nuke +, -, ! at start of lines in diffs (also killing the - lines)
map <silent> <C-z> :%s/^+<CR> :%s/^-.*<CR> :%s/^!<CR>

" saving and exiting
map <silent><leader>w :w<CR>
map <silent><leader>q :q<CR>
" ----------------------------------------------------------------

" print an 80-char line separator
inoremap <silent><C-z> ---------------------------------------------------------------------------<ESC>:Commentary<CR>0o
inoremap <silent><C-s> ------------------------------------------------------- <ESC>:Commentary<CR>0llllllllllllllllllllli

" --------------------------------------------------------------

" ----------- Page Up/Down Functionality ----------------------
function GetNumberOfVisibleLines()
  let cur_line = line(".")
  let cur_col = virtcol(".")
  normal H
  let top_line = line(".")
  normal L
  let bot_line = line(".")
  execute "normal " . cur_line . "G"
  execute "normal " . cur_col . "|"
  return bot_line - top_line
endfunc

function! PageUp()
  let visible_lines = GetNumberOfVisibleLines()
  execute "normal " . visible_lines . "\<C-U><silent>:set scroll=0\r"
endfunction

function! PageDown()
  let visible_lines = GetNumberOfVisibleLines()
  execute "normal " . visible_lines . "\<C-D><silent>:set scroll=0\r"
endfunction

noremap <silent><PageUp> :call PageUp()<CR>
noremap <silent><PageDown> :call PageDown()<CR>
" I switch the f/b keys, and also add them to insert mode.
noremap <silent><C-f> :call PageUp()<CR>
noremap <silent><C-b> :call PageDown()<CR>
imap <silent><C-f> <ESC> :call PageUp()<CR><i>
imap <silent><C-b> <ESC> :call PageDown()<CR><i>
" ---------------------------------------------------------------

" ------------- Unbindings ---------------------------------------
" disable Arrow keys in normal mode
nmap  <silent><up>    <nop>
nmap  <silent><down>  <nop>
nmap  <silent><left>  <nop>
nmap  <silent><right> <nop>
" disable Arrow keys in insert mode
imap <silent><up>     <nop>
imap <silent><down>   <nop>
imap <silent><right>  <nop>
imap <silent><left>   <nop>
" disable binds that conflict with st
map  <silent><c-=>    <nop>
map  <silent><c-->    <nop>
" disable binds that conflict with tabbed
map <silent><C-h>     <nop>
map <silent><C-l>     <nop>
map  <silent><C-n>    <nop>
map  <silent><C-w>    <nop>
" --------------------------------------------------------------------------

" --------------------- Preview Markdown ------------------------------------ "
map <leader>md :!/home/mitch/usr/bin/previewmarkdown.sh -i "%" -b $BROWSER<CR>
" --------------------------------------------------------------------------- "

" ------------------ Open files in ranger (nvim only) ------------------------------------- "
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

" Override netrw
let g:loaded_netrwPlugin = 'disable'
augroup ReplaceNetrwWithRanger
    autocmd StdinReadPre * let s:std_in = 1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | call s:RangerOpenDir(argv()[0]) | endif
augroup END

command! -complete=dir -nargs=* Ranger :call <SID>RangerOpenDir(<f-args>)
" command! -complete=dir -nargs=* RangerCurrentFile :call <SID>RangerOpenDir(expand('%:p:h'), @%)
nnoremap <silent><leader>r :Ranger<CR>
" --------------------------------------------------------------------------- "

" ---------------- Fix TTY Artifacts ---------------------------------------- "
if has("autocmd")
    autocmd VimEnter * redraw!
endif
" --------------------------------------------------------------------------- "

" -------------- character aliases ------------------------------------------ "
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
" --------------------------------------------------------------------------- "

" -------------- reopen vim at previous cursor point ------------------------ "
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END
" --------------------------------------------------------------------------- "
