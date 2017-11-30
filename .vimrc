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

" disables space for everything but as leader
nnoremap <SPACE> <Nop> 
let mapleader=" "
" --------------- plugins -----------------------------------
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin('~/.vim/vim-plug')

" Applications
Plug 'vimwiki/vimwiki'
Plug 'iamcco/markdown-preview.vim'
Plug 'kien/ctrlp.vim' " fuzzy finder

" Themes & Frippery
Plug 'vim-airline/vim-airline-themes' " powerline-inspired status bar
Plug 'vim-airline/vim-airline' " see above -^
Plug 'flazz/vim-colorschemes' " just a bunch of colorschemes
Plug 'altercation/vim-colors-solarized' " solarized colorschemes
Plug 'dracula/vim'  " dracula colorscheme
Plug 'jonathanfilip/vim-lucius' " lucius colorscheme

" UI mods
Plug 'HeroicEric/vim-tabline' " shows full path in tab names

" Syntax Highlighting
Plug 'sheerun/vim-polyglot' " syntax highlight - all languages
Plug 'tpope/vim-markdown' " markdown support
Plug 'pangloss/vim-javascript' " better javascript support
Plug 'lilydjwg/colorizer' " colorizes rgb colorcodes

" Code Completion
Plug 'Shougo/deoplete.nvim' " heavy, parallelized code completion
Plug 'ervandew/supertab' " open code completion with tab

" Utils
Plug 'w0rp/ale' " asynchronous linting in many languages
Plug 'tpope/vim-commentary' " comment toggler
Plug 'terryma/vim-multiple-cursors' " sublime multiple select
Plug 'tpope/vim-surround' " quote/paren etc surrounding
Plug 'airblade/vim-gitgutter' " git diffing and airline integration
Plug 'godlygeek/tabular' " tab alignment
Plug 'AndrewRadev/splitjoin.vim' " conversion from multiline to singleline

call plug#end()
filetype indent plugin on
syntax enable
map <leader>pl :PlugInstall<CR>
map <leader>pu :PlugUpdate<CR>
map <leader>pc :PlugClean<CR>
" --------------------------------------------------------------

" ------------- COLORSCHEME ------------------------------------
colorscheme dracula
" colorscheme solarized
" colorscheme zenburn
" colorscheme newspaper
" colorscheme neverland
" colorscheme lucius

" set background=dark
set background=light

" disables background:
" hi Normal ctermbg=NONE

let g:airline_theme='dracula'
" let g:airline_theme='papercolor'
" let g:airline_theme='solarized'
" let g:airline_theme='zenburn'
" let g:airline_theme='lucius'
" ---------------------------------------------------------------

" -------------- Vim Specific Configs -------------------------
" set mouse=a " NOTE THIS BREAKS MIDDLE CLICK PASTE on some terminals
set backspace=indent,eol,start
set updatetime=500 " how long til vim does background calls after typing

" Enter will now also clear the highlights from searches
nnoremap <silent> <CR> :noh<CR><CR>

" Clear highlighting on escape in normal mode
nnoremap <silent><esc> :noh<return><esc>
nnoremap <silent><esc>^[ <esc>^[
" -------------------------------------------------------------

" ------------ HISTORY ---------------------------------------
set history=500
set undolevels=500
set undoreload=2000
" -----------------------------------------------------------

" ---------- UI ---------------------------------------------
" highlight trailing whitespace:
" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" match ExtraWhitespace /\s\+$\|\t/

set formatoptions+=o " continue comment marker on new lines
set number " enables line numbers on startup
set ruler " show where you are
set relativenumber " shows line numbers relative to position

" Toggle line numbeing on/off
map <silent><leader>ln :set number! relativenumber!<cr>

set tabpagemax=15 " don't allow for more than 15 tabs to be open
set noshowmode
set showmatch " show matching parens
set cursorline " show current line
set colorcolumn=80
" ------------------------------------------------------------

" ------ FORMATTING -----------------------------------------
" set nowrap " dont wrap lines
set encoding=utf-8
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
nnoremap th  :tabfirst<CR>
nnoremap tk  :tabnext<CR>
nnoremap tj  :tabprev<CR>
nnoremap tl  :tablast<CR>

nnoremap <C-h>  :tabfirst<CR>
nnoremap <C-k>  :tabnext<CR>
nnoremap <C-j> :tabprev<CR>
nnoremap <C-l>  :tablast<CR>

nnoremap tt  :tabedit<Space>

nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>
" ------------------------------------------------------------

" ---------- Searching ----------------------------------------
set ignorecase " case insensitive search
set smartcase " if there are uppercase letters, become case-sensitive.
set incsearch " live incremental searching
set showmatch " live match highlighting
set hlsearch " highlight matches
set gdefault " use the `g` flag by default.
set magic " 'magic' patterns - (extended regex)
map <silent><leader>/ :nohlsearch<CR><CR>
" Search and Replace
nmap <Leader>s :%s//g<Left><Left>
" -------------------------------------------------------------

" -------- Language Syntax Management ---------------------------
iab #i #include <.h>
" --------------------------------------------------------------

" -------------- Extension Settings --------------------------
" Use deoplete.
let g:deoplete#enable_at_startup = 1

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
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0 " fucking annoying

" ---------------- airline settings --------------------
let g:airline_powerline_fonts = 1
" airline tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" airline ALE integration
let g:airline#extensions#ale#enabled = 1
" ------------ Vim Wiki ---------------------------------------
let wiki = {}
let g:vimwikidir = "/home/mitch/files/vimwiki"
let wiki.path = g:vimwikidir
let g:vimwiki_list=[wiki]
let g:vimwiki_list = [
            \{'path': '~/files/vimwiki/personal.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/linux.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/programming.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/metal.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/philosophy.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/german.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/french.wiki', 'syntax': 'markdown', 'ext': '.md'},
            \{'path': '~/files/vimwiki/vim.wiki', 'syntax': 'markdown', 'ext': '.md'}
            \]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
map <silent><leader>md :MarkdownPreview<CR>
" --------------------------------------------------------------

" -------- External Programs ---------------------------------
"Make calcurse notes markdown compatible:
autocmd BufRead,BufNewFile /tmp/calcurse* set filetype=markdown
autocmd BufRead,BufNewFile ~/.calcurse/notes/* set filetype=markdown


" Use ranger as a vim file chooser!
function! RangerChooser()
    let temp = tempname()
    exec 'silent !ranger --choosefiles=' . shellescape(temp)
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
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
nnoremap <leader>r :<C-U>RangerChooser<CR>
" -------------------------------------------------------------

" #################### END ########################################

" Not sure what these do:
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" set so=10
" set laststatus=2
