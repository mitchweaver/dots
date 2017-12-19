" https://github.com/MitchWeaver/dotfiles/.vimrc
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

" disables space for everything but as leader (needs fixed)
nnoremap <silent><SPACE> <CR>
let mapleader=" "

" ←--------------- Plugins -----------------------------------→
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin('~/.vim/vim-plug')

" Applications
Plug 'vimwiki/vimwiki'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy finder
" Plug 'iamcco/markdown-preview.vim'

" Themes & Frippery
" Plug 'flazz/vim-colorschemes' " just a bunch of colorschemes
" Plug 'altercation/vim-colors-solarized' " solarized colorschemes
" Plug 'jonathanfilip/vim-lucius' " lucius colorscheme
" Plug 'arcticicestudio/nord-vim'

" UI mods

" Syntax Highlighting
Plug 'sheerun/vim-polyglot' " syntax highlight - all languages
Plug 'lilydjwg/colorizer' " colorizes rgb colorcodes
" Plug 'tpope/vim-markdown' " markdown support
" Plug 'pangloss/vim-javascript' " better javascript support

" Code Completion
Plug 'ervandew/supertab' " open code completion with tab
" Plug 'Shougo/deoplete.nvim' " heavy, parallelized code completion

" Utils
Plug 'tpope/vim-commentary' " comment toggler
Plug 'terryma/vim-multiple-cursors' " sublime multiple select
Plug 'tpope/vim-surround' " quote/paren etc surrounding
Plug 'airblade/vim-gitgutter' " git diffing along the left side
Plug 'godlygeek/tabular' " tab alignment
Plug 'AndrewRadev/splitjoin.vim' " conversion from multiline to singleline
" Plug 'w0rp/ale' " asynchronous linting in many languages

call plug#end()
filetype indent plugin on
syntax enable
map <leader>pi :PlugInstall<CR>
map <leader>pu :PlugUpdate<CR>
map <leader>pc :PlugClean<CR>
map <silent><leader>pa :PlugClean<CR>:PlugInstall<CR>:PlugUpdate<CR>
" --------------------------------------------------------------

" ------------- COLORSCHEME ------------------------------------
" colorscheme newspaper
" colorscheme lucius
" LuciusDarkHighContrast
" LuciusDarkLowContrast
" LuciusLightHighContrast

set background=dark
" set background=light
" hi Normal ctermbg=NONE " disables background:
" ---------------------------------------------------------------

" -------------- Vim Specific Configs -------------------------
set mouse=a " NOTE THIS BREAKS MIDDLE CLICK PASTE on some terminals
set backspace=indent,eol,start
set updatetime=1000 " how long til vim does background calls after typing

" Enter will now also clear the highlights from searches
nnoremap <silent><CR> :noh<CR>:nohlsearch<return><CR>

" Clear highlighting on escape in normal mode
nnoremap <silent><esc> :noh<return>:nohlsearch<return><esc>
nnoremap <silent><esc> ^[ <esc>^[

" Disable bottom status line / statusbar
set laststatus=0

" makes vim yank/paste to/from the system clipboard
set clipboard=unnamed
set vb " disable audible bell
set novisualbell " kill the visual bell too
set noerrorbells " did I mention I hate bells?
set lazyredraw " whether to redraw screen after macros
set mat=2 " how fast to blink matched brackets
set ch=1 " command height --- get rid of the wasted line at the bottom
set textwidth=0 " very annoying warning occurs with long lines
set backspace=2 " allow backspace to go over new lines, etc
set ttimeoutlen=100 " timeout between key presses for cmds
" -------------------------------------------------------------

" ---------------- OS Specific Configs ------------------------
set shellslash
set shell=ksh
set wildmenu " makes shell completion a bit better
" -------------------------------------------------------------

" ------------ HISTORY ---------------------------------------
set history=750
set undolevels=500
set undoreload=2000
" -----------------------------------------------------------

" ---------- UI ---------------------------------------------
" highlight trailing whitespace - (annoying imo)
" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" match ExtraWhitespace /\s\+$\|\t/

set formatoptions+=o " continue comment marker on new lines

set ruler " show where you are in the bottom right

" ~~~ I prefer these two disabled at startup, see function below
" set number " enables line numbers on startup
" set relativenumber " shows line numbers relative to position

" Toggle line numbering on/off
map <silent><leader>ln :set number! relativenumber!<cr>

set noshowmode " don't show 'insert' or 'normal' etc on bottom left
set showmatch " show matching parens

" WARNING - this is *very* slow, I have it disabled
" set cursorline " show current line

" Nice, but this can be annoying on some color schemes
" set colorcolumn=80

set scrolloff=4 " keep cursor X lines from the top/bottom when scrolling
set mousehide " hide the mouse while typing (doesn't work on openbsd?)

set fillchars=""  " extremely annoying, they serve no purpose

" don't syntax highlight lines that are too long (slow)
set synmaxcol=1024
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

map <silent>tt  :tabedit<Space>
map <silent>tn  :tabnew<CR>
map <silent>tm  :tabm<Space>
map <silent>td  :tabclose<CR>
" ------------------------------------------------------------

" ---------- Searching ----------------------------------------
set ignorecase " case insensitive search
set smartcase " if there are uppercase letters, become case-sensitive.
set incsearch " live incremental searching
set showmatch " live match highlighting
set hlsearch " highlight matches
set gdefault " use the `g` flag by default.
set wrapscan " searching wraps lines
set magic " 'magic' patterns - (extended regex)
" map <silent><leader>/ :nohlsearch<CR>
" Search and Replace
nmap <Leader>s :%s//g<Left><Left>
" -------------------------------------------------------------

" -------- Language Syntax Management ---------------------------
iab #i #include <.h>
" --------------------------------------------------------------

" -------------- Extension Settings --------------------------
" Use deoplete.
" let g:deoplete#enable_at_startup = 1

" disable all gitgutter keybinds
let g:gitgutter_map_keys = 0
" only run gitgutter on save
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<c-n>'
let g:multi_cursor_prev_key='<c-p>'
let g:multi_cursor_skip_key='<c-x>'
let g:multi_cursor_quit_key='<esc>'

" map the key for toggling comments with vim-commentary
nmap <silent><leader>c :Commentary<CR>

" ---------- Ale settings ----------------------------
" only lint on file save, not in background or on file open:
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
" Disable warnings about trailing whitespace for Python files.
" let b:ale_warn_about_trailing_whitespace = 0 " fucking annoying

" ------------ Vim Wiki ---------------------------------------
let wiki = {}
let g:vimwikidir = "/home/mitch/files/vimwiki"
let wiki.path = g:vimwikidir
let g:vimwiki_list=[wiki]
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_list = [
            \{'path': '~/files/vimwiki/personal.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/linux-BSD.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/programming.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/metal.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/philosophy.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/german.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/french.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/vim.wiki', 'syntax': 'markdown', 'ext': '.md'}
            \]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
map <silent><leader>md :MarkdownPreview<CR>

" ctrlp ignores
set wildignore+=/home/mitch/music,/home/mitch/videos,/home/mitch/books,/home/mitch/images,*.opus,*.flac,*.pdf,*.jpg,*.png,*.so,*.swp,*.zip,*.gzip,*.bz2,*.tar,*.xz,*.lrzip,*.lrz,*.mp3,*.ogg,*.mp4,*.gif,*.jpeg,*.webm
" --------------------------------------------------------------

" ------ misc keybinds -------------------------------------------
"  Make shift-insert work (better if you can just make your terminal do it)
" map <silent><S-Insert> <MiddleMouse>
" map! <silent><S-Insert> <MiddleMouse>

" Horizontal scrolling
nmap <silent> <C-o> 10zl
nmap <silent> <C-i> 10zh
" ----------------------------------------------------------------

" ----------------- Symbol Printing -----------------------------
" ~~~ NOTE: I know you can do these with default vim, ctrl-k 
" conflicts with my own bindings. Plus, I think this way is easier. 

" ~~~~~~ Greek Symbols ~~~~~ "
" lambda
imap <silent><C-q><C-l> λ
" theta
imap <silent><C-q><C-t> Θ
" delta
imap <silent><C-q><C-d> Δ 
" pi
imap <silent><C-q><C-p> π
" mu
imap <silent><C-q><C-u> μ
" omega
imap <silent><C-q><C-o> Ω
" phi
imap <silent><C-q><C-[> Φ
" kappa
imap <silent><C-q><C-k> κ
" sigma
imap <silent><C-q><C-s> ∑

" ~~~~ Logical Symbols ~~~~~ "
" bullet / dot operator
imap <silent><C-q><C-b> ∙
" therefore
imap <silent><C-q><C-.> ∴
" because
imap <silent><C-q><C-,> ∵
" member of 
imap <silent><C-q><C-3> ∋
" element of
imap <silent><C-q><C-e> ∈
" Null set
imap <silent><C-q><C-0> ∅
" for all
imap <silent><C-q><C-a> ∀
" right arrow
imap <silent><C-q><C-Right> →
" left arrow
imap <silent><C-q><C-Left> ←
" up arrow
imap <silent><C-q><C-Up> ↑
" down arrow
imap <silent><C-q><C-Down> ↓
" there exists
imap <silent><C-q><C-E> ∃

" ~~~~~~ Mathematics ~~~~~~~ "
" sqrt
imap <silent><C-q><C-s><C-q> √
" infinity
imap <silent><C-q><C-i> ∞
" squared
imap <silent><C-q><C-2> ²
" plus/minus
imap <silent><C-q><C-p> ±
" roughly equivalent
imap <silent><C-q><C-~> ≈
" not equal to
imap <silent><C-q><C-/> ≠
" greater than/equal to
imap <silent><C-q><C-g> ≥
" less than/equal to
imap <silent><C-q><C-l> ≤

" ~~~~~~~~ Misc ~~~~~~~~~~~~ "
" trademark symbol
imap <silent><C-q><C-t><C-m> ™
" copyright symbol
imap <silent><C-q><C-c><C-r> ©
" left guillemet
imap <silent><C-q><C-]> »
" right guillemet
imap <silent><C-q><C-[> «

" Things I don't use but might be cool:
" (calculus) integrals: ∫∬∮

" print an 80-char line separator
inoremap <silent><C-b> -------------------------------------------------------------------------- <ESC>:Commentary<CR>$o
" --------------------------------------------------------------

" -------- External Programs ---------------------------------
"Make calcurse notes markdown compatible:
autocmd BufRead,BufNewFile /tmp/calcurse* set filetype=markdown
autocmd BufRead,BufNewFile ~/.calcurse/notes/* set filetype=markdown

" Use ranger as a vim file chooser!
function! RangerChooser()
    let temp = tempname()
   
    exec 'silent !st -e ranger --choosefiles=' . shellescape(temp)

    " ~~~ This does not work for me. I get 'Error: Must start from terminal'
    " exec 'silent !ranger --choosefiles=' . shellescape(temp)
    
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction
command! -bar RangerChooser call RangerChooser()
nnoremap <silent><leader>r :<C-U>RangerChooser<CR>
" -------------------------------------------------------------
