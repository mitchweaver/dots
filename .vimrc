"      ▌    ▗           
" ▗▖▖ ▞  ▌ ▌▄ ▛▚▀▖▙▀▖▞▀▖
" ▘▝ ▞   ▐▐ ▐ ▌▐ ▌▌  ▌ ▖
"    ▘ ▝  ▘ ▀▘▘▝ ▘▘  ▝▀ 
" http://github.com/mitchweaver/dots

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▜▘   ▗▐  
" ▐ ▛▀▖▄▜▀ 
" ▐ ▌ ▌▐▐ ▖
" ▀▘▘ ▘▀▘▀ 
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" unbind space for everything but leader
nnoremap <silent><SPACE> <nop>
let mapleader=" "

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▛▀▖▜       ▗       
" ▙▄▘▐ ▌ ▌▞▀▌▄ ▛▀▖▞▀▘
" ▌  ▐ ▌ ▌▚▄▌▐ ▌ ▌▝▀▖
" ▘   ▘▝▀▘▗▄▘▀▘▘ ▘▀▀ 
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set nocompatible
filetype off
call plug#begin('~/.vim/vim-plug')

Plug 'tpope/vim-repeat' " allows '.' to do more things
Plug 'tpope/vim-speeddating' " allows C-a to increment dates and times
Plug 'godlygeek/tabular' " tab alignment
Plug 'sheerun/vim-polyglot' " syntax highlighting
Plug 'ekalinin/Dockerfile.vim' " syntax for dockerfiles

Plug 'ap/vim-buftabline' " display buffers along top as tabs
    let g:buftabline_show = 1

Plug 'tpope/vim-commentary' " comment toggler
    nmap <silent><leader>c :Commentary<CR>
    autocmd FileType asm setlocal commentstring=;\ %s
    autocmd FileType conf setlocal commentstring=#\ %s
    autocmd FileType rc setlocal commentstring=#\ %s
    autocmd BufNewFile,BufRead pkgfile setlocal commentstring=#\ %s

Plug 'terryma/vim-multiple-cursors' " sublime-like multiple select
    let g:multi_cursor_use_default_mapping=0
    let g:multi_cursor_next_key='<c-m>'
    let g:multi_cursor_prev_key='<c-p>'
    let g:multi_cursor_skip_key='<c-x>'
    let g:multi_cursor_quit_key='<esc>'

Plug 'airblade/vim-gitgutter' " git diffing along the left side
    let g:gitgutter_map_keys = 0 " disable all gitgutter keybinds
    let g:gitgutter_realtime = 0 " only run gitgutter on save
    set signcolumn=auto " yes=always, no=never, auto=ifchanges
    map <silent><leader>g :GitGutterToggle<CR>
    nmap ]h <Plug>GitGutterNextHunk
    nmap [h <Plug>GitGutterPrevHunk
    nmap <Leader>hs <Plug>GitGutterStageHunk
    nmap <Leader>hr <Plug>GitGutterUndoHunk

Plug 'tpope/vim-surround' " surround stuff with stuff
	nmap ss ysiw
	nmap sl yss
	vmap s S

Plug 'jiangmiao/auto-pairs' " autotype brackets, parents, tags
    let g:AutoPairsFlyMode = 0
    let g:AutoPairsShortcutBackInsert = '<M-b>'

Plug 'ervandew/supertab' " insert mode tab completion

Plug 'Yggdroot/indentLine' " show indentation lines
    let g:indentLine_enabled = 1

Plug 'maxboisvert/vim-simple-complete' " testing this out
    let g:vsc_type_complete_length = 1
    set complete=.,w,b,u,t,i

Plug 'chrisbra/Colorizer' " colorize hex codes in terminal
    autocmd VimEnter * ColorHighlight
    let g:colorizer_auto_color = 1
    let g:termguicolors = 1

Plug 'w0rp/ale'
    let g:ale_sign_column_always = 1
    let g:ale_fix_on_save = 1
    " uncomment to only have ale check on file saves
    """""let g:ale_lint_on_text_changed = 'never'
    let g:airline#extensions#ale#enabled = 1

Plug 'ryanoasis/vim-devicons' " adds icons to plugins

Plug 'danilo-augusto/vim-afterglow' " theme based on sublime text
    let g:afterglow_inherit_background=1 " use same background color as terminal
    let g:afterglow_italic_comments=1

Plug 'sonph/onehalf', {'rtp': 'vim/'} " theme

call plug#end()
filetype indent plugin on

if exists(':PlugInstall')
    map <silent><leader>pi :PlugInstall<CR>
    map <silent><leader>pu :PlugUpdate<CR>
    map <silent><leader>pc :PlugClean<CR>
    " -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
    " NOTE: colorschemes must be set after loading plugins
    " colorscheme afterglow
    colorscheme onehalfdark
    " -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
    set background=dark
    set t_Co=256 " fix terminal colors
    set termguicolors
endif

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▛▀▘     ▐  
" ▙▄▞▀▖▛▀▖▜▀ 
" ▌ ▌ ▌▌ ▌▐ ▖
" ▘ ▝▀ ▘ ▘ ▀ 
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set guifont=Hack:h12
" set guifont=IBM\ Plex\ Mono:h12
" set guifont=ShureTechMono\ Nerd\ Font:h12

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▞▀▖               ▜ 
" ▌▄▖▞▀▖▛▀▖▞▀▖▙▀▖▝▀▖▐ 
" ▌ ▌▛▀ ▌ ▌▛▀ ▌  ▞▀▌▐ 
" ▝▀ ▝▀▘▘ ▘▝▀▘▘  ▝▀▘ ▘
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
scriptencoding utf-8
set cursorline " highlight current line of cursor
set encoding=utf-8
set history=200
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set updatetime=750
set clipboard=unnamedplus
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
set mouse=a " enable mouse globally

" remove need to hold shift for commands
noremap ; :
" make :W still save
noremap :W :w
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▞▀▖      ▐        
" ▚▄ ▌ ▌▛▀▖▜▀ ▝▀▖▚▗▘
" ▖ ▌▚▄▌▌ ▌▐ ▖▞▀▌▗▚ 
" ▝▀ ▗▄▘▘ ▘ ▀ ▝▀▘▘ ▘
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
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

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▌  ▗        ▙ ▌       ▌           
" ▌  ▄ ▛▀▖▞▀▖ ▌▌▌▌ ▌▛▚▀▖▛▀▖▞▀▖▙▀▖▞▀▘
" ▌  ▐ ▌ ▌▛▀  ▌▝▌▌ ▌▌▐ ▌▌ ▌▛▀ ▌  ▝▀▖
" ▀▀▘▀▘▘ ▘▝▀▘ ▘ ▘▝▀▘▘▝ ▘▀▀ ▝▀▘▘  ▀▀ 
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
map <silent><leader>ln :set number!<cr>
map <silent><leader>nl :set relativenumber!<cr>
set number! " start with line numbering enabled

" set color column width to 72 chars
" editor will start with it hidden, but allow it
" it to be toggleable with leader + 'll'
let s:color_column_old = 72
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

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▞▀▖▐     ▜    
" ▚▄ ▜▀ ▌ ▌▐ ▞▀▖
" ▖ ▌▐ ▖▚▄▌▐ ▛▀ 
" ▝▀  ▀ ▗▄▘ ▘▝▀▘
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab " use spaces instead of tabs.
set smarttab " soft tab creation / deletion
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " match indents on new lines.
set smartindent

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▞▀▖            ▗                                
" ▙▄▌▛▀▖▛▀▖▞▀▖▌ ▌▄ ▛▀▖▞▀▌ ▛▀▖▞▀▖▛▀▖▞▀▘▞▀▖▛▀▖▞▀▘▞▀▖
" ▌ ▌▌ ▌▌ ▌▌ ▌▚▄▌▐ ▌ ▌▚▄▌ ▌ ▌▌ ▌▌ ▌▝▀▖▛▀ ▌ ▌▝▀▖▛▀ 
" ▘ ▘▘ ▘▘ ▘▝▀ ▗▄▘▀▘▘ ▘▗▄▘ ▘ ▘▝▀ ▘ ▘▀▀ ▝▀▘▘ ▘▀▀ ▝▀▘
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set vb " disable audible bell
set novisualbell " kill the visual bell too
set noerrorbells " did I mention I hate bells?
set nobackup " we have vcs, we don't need backups.
set nowritebackup " we have vcs, we don't need backups.
set noswapfile " annoying

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▛▀▖   ▗▀▖▗▀▖         
" ▙▄▘▌ ▌▐  ▐  ▞▀▖▙▀▖▞▀▘
" ▌ ▌▌ ▌▜▀ ▜▀ ▛▀ ▌  ▝▀▖
" ▀▀ ▝▀▘▐  ▐  ▝▀▘▘  ▀▀ 
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set hidden " allow buffers with unsaved changes
set autoread " reload files if changed on disk

" b <num> = go to $buffer
nnoremap <Leader>b :b 

map <silent><C-d> :bd<cr>
map <silent>tk :bnext<CR>
map <silent>tj :bprev<CR>
map <silent>td :bd<cr>


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
nmap <leader>s :%s//g<Left><Left>

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▌ ▌      ▌     
" ▙▄▌▝▀▖▞▀▖▌▗▘▞▀▘
" ▌ ▌▞▀▌▌ ▖▛▚ ▝▀▖
" ▘ ▘▝▀▘▝▀ ▘ ▘▀▀ 
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" execute line as shell command and replace it with output
noremap <leader>W !!sh<cr>
" pipe line to fmt and replace current line
noremap F !!fmt<cr>
" prepend '> ' to lines as if to block quote
noremap Q :norm 0i> <esc>$

noremap <leader>T !!toilet -f smblock<cr>

" view open file in rendered markdown
nmap <leader>md :!smu "%:p" >/tmp/tmp.html && $BROWSER /tmp/tmp.html<CR>
nmap <leader>ghmd :!ghmd2html "%:p" >/tmp/tmp.html && $BROWSER /tmp/tmp.html<CR>

set wildignore+=*.opus,*.flac,*.pdf,*.jpg,*.png,*.so,*.swp,*.zip,*.gzip,*.bz2,*.tar,*.xz,*.lrzip,*.lrz,*.mp3,*.ogg,*.mp4,*.gif,*.jpeg,*.webm

" horizontal scrolling
noremap <silent><C-o> 10zl
noremap <silent><C-i> 10zh

" swap f/b -- i know, i'm a madman
noremap <silent><C-f> <C-b>
noremap <silent><C-b> <C-f>

map <silent><leader>w :w<CR>
map <silent><leader>q :q<CR>

" print a 60-char line separator, commented
map <C-s> 30i-*<ESC>:Commentary<CR>
map <C-d> 30i-/<ESC>:Commentary<CR>

" conflicts with st/tabbed:
map  <silent><c-=> <nop>
map  <silent><c--> <nop>
" map  <silent><C-w> <nop>

augroup resCur "reopen vim at previous cursor point
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▛▀▖               
" ▙▄▘▝▀▖▛▀▖▞▀▌▞▀▖▙▀▖
" ▌▚ ▞▀▌▌ ▌▚▄▌▛▀ ▌  
" ▘ ▘▝▀▘▘ ▘▗▄▘▝▀▘▘  
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
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

" ranger
let g:ranger_map_keys = 0
nnoremap <silent><leader>r :Ranger<CR>

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ▞▀▖   ▜ ▗▐     
" ▚▄ ▛▀▖▐ ▄▜▀ ▞▀▘
" ▖ ▌▙▄▘▐ ▐▐ ▖▝▀▖
" ▝▀ ▌   ▘▀▘▀ ▀▀ 
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" ---- cant get below working right, annoying
"  for now, just keep using default split bindings
"
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" C-w-hjkl --- moving
" C-w-v --- vertical split
" C-w-s --- horis split
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

" func! WinMove(key)
"     let t:curwin = winnr()
"     exec "wincmd ".a:key
"     if (t:curwin == winnr())
"         if (match(a:key,'[jk]'))
"             wincmd v
"         else
"             wincmd s
"         endif
"         exec "wincmd ".a:key
"     endif
" endfu
 
" nnoremap <silent><C-h> :call WinMove('h')<cr>
" nnoremap <silent><C-j> :call WinMove('j')<cr>
" nnoremap <silent><C-k> :call WinMove('k')<cr>
" nnoremap <silent><C-l> :call WinMove('l')<cr>
" set fillchars+=vert:│
