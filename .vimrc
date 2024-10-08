" http://github.com/mitchweaver/dots
" -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

" ██╗███╗   ██╗██╗████████╗
" ██║████╗  ██║██║╚══██╔══╝
" ██║██╔██╗ ██║██║   ██║
" ██║██║╚██╗██║██║   ██║
" ██║██║ ╚████║██║   ██║
" ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" unbind space for everything but leader
nnoremap <silent><SPACE> <nop>
let mapleader=" "

" ██████╗ ██╗     ██╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
" ██╔══██╗██║     ██║   ██║██╔════╝ ██║████╗  ██║██╔════╝
" ██████╔╝██║     ██║   ██║██║  ███╗██║██╔██╗ ██║███████╗
" ██╔═══╝ ██║     ██║   ██║██║   ██║██║██║╚██╗██║╚════██║
" ██║     ███████╗╚██████╔╝╚██████╔╝██║██║ ╚████║███████║
" ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

set nocompatible
filetype off
call plug#begin('~/.vim/vim-plug')

" NEOVIM ONLY
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        let g:deoplete#enable_at_startup = 1

    Plug 'w0rp/ale'
    let g:ale_sign_column_always = 0
        let g:ale_fix_on_save = 1
        " uncomment to only have ale check on file saves
        let g:ale_lint_on_text_changed = 'never'
        let g:airline#extensions#ale#enabled = 1
        let g:ale_linters = {'python': ['pylint']}
        let g:ale_python_pylint_options = '--rcfile ~/.pylintrc'
        " to never show hints
        let g:ale_virtualtext_cursor = 'disabled'
endif

Plug 'tpope/vim-repeat'          " allows '.' to do more things
Plug 'tpope/vim-speeddating'     " allows C-a to increment dates and times
Plug 'tpope/vim-eunuch'          " wrapper around common unix shell commands
Plug 'tpope/vim-sleuth'          " autodetect tab indentation
Plug 'tpope/vim-abolish'         " bracket {,} expansion in substitution
Plug 'tpope/vim-unimpaired'      " pairing of binds with '[' and ']'
Plug 'tpope/vim-endwise'         " automatch endings of structures
Plug 'tpope/vim-surround'        " surround stuff with stuff
    nmap ss ysiw
    nmap sl yss
    vmap s S
Plug 'tpope/vim-commentary'      " comment toggler
    nmap <silent><leader>c :Commentary<CR>
    autocmd BufNewFile,BufRead *.asm setlocal commentstring=;\ %s
    autocmd BufNewFile,BufRead *.conf setlocal commentstring=#\ %s
    autocmd BufNewFile,BufRead *.local setlocal commentstring=#\ %s
    autocmd BufNewFile,BufRead *rc setlocal commentstring=#\ %s
    autocmd BufNewFile,BufRead *.cfg setlocal commentstring=#\ %s
    autocmd BufNewFile,BufRead *.config setlocal commentstring=#\ %s
    autocmd BufNewFile,BufRead *.profile setlocal commentstring=#\ %s
    autocmd BufNewFile,BufRead pkgfile setlocal commentstring=#\ %s
    autocmd BufNewFile,BufRead *.h setlocal commentstring=\/\/\ %s
    " autocmd BufNewFile,BufRead *.md setlocal commentstring=\<\!--%s--\>

Plug 'godlygeek/tabular'         " tab alignment
Plug 'svermeulen/vim-yoink'      " emacs killring for vim
Plug 'dstein64/vim-startuptime'  " useful for debugging slow plugins
Plug 'chrisbra/unicode.vim'      " easily search and copy unicode chars
Plug 'ryanoasis/vim-devicons'    " adds icons to plugins
Plug 'psliwka/vim-smoothie'      " smooth scrolling done right
Plug 'https://github.com/farmergreg/vim-lastplace' " remember last place in files

Plug 'unblevable/quick-scope'    " make f F t T ; and , useable 
    " trigger highlight only with 'f' and 'F'
    let g:qs_highlight_on_keys = ['f', 'F']

Plug 'preservim/vim-wordy'       " make me write gooder
    noremap <silent><F8> :<C-u>NextWordy<cr>
    xnoremap <silent><F8> :<C-u>NextWordy<cr>
    inoremap <silent><F8> <C-o>:NextWordy<cr>
    if !&wildcharm | set wildcharm=<C-z> | endif
    execute 'nnoremap <leader>w :Wordy<space>'.nr2char(&wildcharm)

Plug 'ap/vim-buftabline' " display buffers along top as tabs
    " uncomment to hide tab if there is only one buffer
    " let g:buftabline_show = 1

Plug 'mg979/vim-visual-multi' " sublime-like multiple select
    let g:VM_default_mappings = 0
    let g:VM_mouse_mappings = 0
    let g:VM_maps = {}
    " let g:VM_maps["Undo"] = 'u'
    " let g:VM_maps["Redo"] = '<C-r>'
    " let g:VM_maps['Select All']  = '<M-n>'
    " let g:VM_maps['Visual All']  = '<M-n>'
    let g:VM_maps['Find Under']         = '<C-d>'
    let g:VM_maps['Find Subword Under'] = '<C-d>'
    let g:VM_maps['Skip Region'] = '<C-x>'
    " let g:VM_maps["Select Cursor Down"] = '<M-C-Down>'
    " let g:VM_maps["Select Cursor Up"]   = '<M-C-Up>'

Plug 'airblade/vim-gitgutter' " git diffing along the left side
    hi signColumn ctermbg=NONE " make sign column same color as terminal background
    let g:gitgutter_enabled = 0 " disable on startup, toggle with leader+g
    let g:gitgutter_map_keys = 0 " disable all gitgutter keybinds
    let g:gitgutter_realtime = 0 " only run gitgutter on save
    let g:gitgutter_earer = 1
    let g:gitgutter_max_signs = 500
    let g:gitgutter_diff_args = '-w'
    let g:gitgutter_sign_added = '+'
    let g:gitgutter_sign_modified = '~'
    let g:gitgutter_sign_removed = '-'
    let g:gitgutter_sign_removed_first_line = '^'
    let g:gitgutter_sign_modified_removed = ':'
    nmap <silent><leader>g :GitGutterToggle<CR>
    " nmap <Leader>gn <Plug>(GitGutterNextHunk)
    " nmap <Leader>gp <Plug>(GitGutterPrevHunk)
    " nmap <Leader>gs <Plug>(GitGutterStageHunk)
    " nmap <Leader>gu <Plug>(GitGutterUndoHunk)

" Plug 'honza/vim-snippets' " snippets repo
" Plug 'SirVer/ultisnips' " snippet driver
"     let g:UltiSnipsExpandTrigger="<c-l>"
"     let g:UltiSnipsListSnippets = '<c-cr>'
"     let g:UltiSnipsEditSplit="vertical"

Plug 'ervandew/supertab' " tab completion rather than <c-n>
    let g:SuperTabDefaultCompletionType = "<c-n>"

Plug 'Yggdroot/indentLine' " show indentation lines
    let g:indentLine_enabled = 0
    nmap <leader>il :let g:indentLine_enabled = 1<CR>
    nmap <leader>li :let g:indentLine_enabled = 0<CR>

" Note: I like using ranger script at the bottom more than nerd tree
" Plug 'preservim/nerdtree'
"     nnoremap <C-n> :NERDTreeToggle<CR>
"     nnoremap <leader>n :NERDTreeToggle<CR>
"     nnoremap <leader>f :NERDTreeFind<CR>
"     " Exit Vim if NERDTree is the only window left.
"     autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
"         \ quit | endif
"     " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
"     autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
"         \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
"     " Open the existing NERDTree on each new tab.
"     autocmd BufWinEnter * silent NERDTreeMirror
"     let g:NERDTreeDirArrowExpandable = '▸'
"     let g:NERDTreeDirArrowCollapsible = '▾'

" -------------------------------------------------------------
" SYNTAXES
" -------------------------------------------------------------
Plug 'ekalinin/Dockerfile.vim'
Plug 'isobit/vim-caddyfile'

Plug 'gentoo/gentoo-syntax' " gentoo ebuild syntax
    set rtp+=/usr/share/vim/vimfiles

Plug 'terminalnode/sway-vim-syntax'
Plug 'waycrate/swhkd-vim'
Plug 'fladson/vim-kitty'

" I don't care for polyglot's markdown/toml syntaxes
Plug 'sheerun/vim-polyglot'
    let g:polyglot_disabled = ['markdown']
    let g:polyglot_disabled = ['markdown.plugin']
    let g:polyglot_disabled = ['toml.plugin']

Plug 'gabrielelana/vim-markdown'
    let g:markdown_enable_conceal = 0
    let g:markdown_enable_input_abbreviations = 0
    let g:markdown_enable_spell_checking = 0
    let g:markdown_enable_mappings = 0
    let g:markdown_enable_folding = 0
    let g:markdown_include_jekyll_support = 0

Plug 'cespare/vim-toml'

" -------------------------------------------------------------
"  THEMES
" -------------------------------------------------------------
Plug 'sonph/onehalf', {'rtp': 'vim/'} " theme
Plug 'logico/typewriter-vim' " theme
Plug 'https://github.com/NLKNguyen/papercolor-theme' " theme
Plug 'AlphaTechnolog/pywal.nvim', { 'as': 'pywal' }
Plug 'kvrohit/mellow.nvim' " theme

Plug 'sainnhe/everforest' " theme
    " Available values: 'hard', 'medium'(default), 'soft'
    let g:everforest_background = 'soft'
    " let g:everforest_background = 'medium'

call plug#end()
filetype indent plugin on

if exists(':PlugInstall')
    map <silent><leader>pi :PlugInstall<CR>
    map <silent><leader>pu :PlugUpdate<CR>
    map <silent><leader>pc :PlugClean<CR>
endif

" ========================================================================
" THEME LOADING (must be after end of plug)
" ========================================================================
" colorscheme onehalfdark
" colorscheme everforest
" colorscheme papercolor
" colorscheme typewriter
" colorscheme mellow
" set background=light
" set background=dark

" if has('termguicolors')
"     set termguicolors
" endif

" force usage of terminal scheme background instead
" of editor scheme -- this allows to respect of terminal transparency
hi Normal guibg=none

" ========================================================================
" NEOVIDE / GUI SPECIFIC
" ========================================================================
" set guifont=Source\ Code\ Pro:h14
set linespace=0

" g:neovide_transparency should be 0 if you want to unify
" transparency of content and title bar
let g:neovide_transparency = 0.0
let g:transparency = 0.9
let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:transparency))
let g:neovide_floating_blur_amount_x = 2.0
let g:neovide_floating_blur_amount_y = 2.0
let g:neovide_scroll_animation_length = 0.3
let g:neovide_refresh_rate = 117
let g:neovide_remember_window_size = v:true
" STUPID ANIMATION
let g:neovide_cursor_animation_length = 0.0
let g:neovide_cursor_trail_size = 0.0
let g:neovide_cursor_antialiasing = v:true

" ========================================================================

"  ██████╗ ███████╗███╗   ██╗███████╗██████╗  █████╗ ██╗
" ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔══██╗██╔══██╗██║
" ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ██████╔╝███████║██║
" ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║██║
" ╚██████╔╝███████╗██║ ╚████║███████╗██║  ██║██║  ██║███████╗
"  ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
scriptencoding utf-8
set encoding=utf-8

" fix graphical bugs in kitty
let &t_ut=''

"---- a = enabled
"---- v = disabled
" set mouse=a
set mouse=v

set signcolumn=auto     " yes=always, no=never, auto=ifchanges
set history=200
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set updatetime=500
"
" =============== CLIPBOARD =================================
"""""""""""""""""""""""""""""""""""""" FIX THIS LATER
" set clipboard=unnamedplus
set clipboard=unnamed
"""""""""""nnoremap <silent><ctrl+v>
" ===========================================================
"
set lazyredraw          " whether to redraw screen after macros
set mat=2               " how fast to blink matched brackets
set textwidth=0         " very annoying warning
set backspace=2         " allow backspace to go over new lines
set title               " keep window name updated with current file
set noruler             " don't show file position in the bottom right
set laststatus=0        " Disable bottom status line / statusbar
set noshowcmd           " don't print the last run command
set ch=1                " get rid of the wasted line at the bottom
set cmdheight=1         " cmd output only take up 1 line
set nostartofline       " gg/G do not always go to line start
set modeline            " enable per-file custom syntax
set shortmess+=I        " disable startup message
" set noshowmode        " don't show 'insert' or etc on bottom left
" set cursorline " highlight current line of cursor

" remove need to hold shift for commands
noremap ; :
" allow operations if we accidentally held shift
noremap :W :w
noremap :W! :w!
noremap :Q :q
noremap :Q! :q!

" ███████╗██╗   ██╗███╗   ██╗████████╗ █████╗ ██╗  ██╗
" ██╔════╝╚██╗ ██╔╝████╗  ██║╚══██╔══╝██╔══██╗╚██╗██╔╝
" ███████╗ ╚████╔╝ ██╔██╗ ██║   ██║   ███████║ ╚███╔╝ 
" ╚════██║  ╚██╔╝  ██║╚██╗██║   ██║   ██╔══██║ ██╔██╗ 
" ███████║   ██║   ██║ ╚████║   ██║   ██║  ██║██╔╝ ██╗
" ╚══════╝   ╚═╝   ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
autocmd BufNewFile,BufRead *.config  set syntax=sh
autocmd BufNewFile,BufRead *.conf    set syntax=sh
autocmd BufNewFile,BufRead *.cfg     set syntax=sh
autocmd BufNewFile,BufRead *.rc      set syntax=sh
autocmd BufNewFile,BufRead *.shellrc set syntax=sh
autocmd BufNewFile,BufRead *.local   set syntax=sh
autocmd BufNewFile,BufRead pkgfile   set syntax=sh

autocmd BufNewFile,BufRead *.c       set syntax=c
autocmd BufNewFile,BufRead *.patch   set syntax=c
autocmd BufNewFile,BufRead *.hs      set syntax=haskell
autocmd BufNewFile,BufRead *.py      set syntax=python
autocmd BufNewFile,BufRead *.pl      set syntax=perl
autocmd BufNewFile,BufRead *.txt     set syntax=off
autocmd BufNewFile,BufRead *.pad     set syntax=markdown
autocmd BufNewFile,BufRead *.note     set syntax=markdown
autocmd BufNewFile,BufRead *.asm     setlocal ft=nasm
autocmd BufNewFile,BufRead *.md      set syntax=markdown

autocmd BufNewFile,BufRead /tmp/mutt-* set tw=72
augroup filetypedetect
  autocmd BufRead,BufNewFile *mutt-*   setfiletype mail
augroup END

let g:is_posix = 1
let g:asmsyntax = 'nasm'
map <silent><leader>sy :set syntax=sh<cr>
filetype plugin on       " vim plugin syntax

" ▜ ▗                  ▌
" ▐ ▄ ▛▀▖▞▀▖ ▛▀▖▌ ▌▛▚▀▖▛▀▖▞▀▖▙▀▖▞▀▘
" ▐ ▐ ▌ ▌▛▀  ▌ ▌▌ ▌▌▐ ▌▌ ▌▛▀ ▌  ▝▀▖
"  ▘▀▘▘ ▘▝▀▘ ▘ ▘▝▀▘▘▝ ▘▀▀ ▝▀▘▘  ▀▀
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
map <silent><leader>ln :set number!<cr>
map <silent><leader>nl :set relativenumber!<cr>


"""""""""""""""""""""""""""""""""" set number! " start with line numbering enabled

" set color column width to 80 chars
" editor will start with it hidden, but allow it
" it to be toggleable with leader + 'll'
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

set showmatch           " show matching parens
set scrolloff=8         " pad X lines when scrolling
set fillchars=""        " extremely annoying
set diffopt+=iwhite     " disable white space diffing
set formatoptions+=o    " continue comments new lines
set synmaxcol=512
set nowrap

" ███████╗████████╗██╗   ██╗██╗     ███████╗
" ██╔════╝╚══██╔══╝╚██╗ ██╔╝██║     ██╔════╝
" ███████╗   ██║    ╚████╔╝ ██║     █████╗  
" ╚════██║   ██║     ╚██╔╝  ██║     ██╔══╝  
" ███████║   ██║      ██║   ███████╗███████╗
" ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚══════╝
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab         " use spaces instead of tabs
set smarttab          " soft tab creation / deletion
set shiftround        " tab / shifting moves to closest tabstop
set autoindent        " match indents on new lines
set smartindent
set breakindent       " set indents when wrapped
" darken inactive panes --- taken from xero.nu
" hi ActiveWindow ctermbg=0 | hi InactiveWindow ctermbg=234
" set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow

" " textwidth auto-wrapping
" augroup textwidth
" 	autocmd!
" 	autocmd FileType text,mail,markdown,gmi setlocal textwidth=80
" augroup END

" " spellcheck
" augroup spelling
" 	autocmd!
" 	autocmd FileType text,mail,markdown,gmi setlocal spell
" augroup END

" ███╗   ██╗ ██████╗ ███╗   ██╗███████╗███████╗███╗   ██╗███████╗███████╗
" ████╗  ██║██╔═══██╗████╗  ██║██╔════╝██╔════╝████╗  ██║██╔════╝██╔════╝
" ██╔██╗ ██║██║   ██║██╔██╗ ██║███████╗█████╗  ██╔██╗ ██║███████╗█████╗  
" ██║╚██╗██║██║   ██║██║╚██╗██║╚════██║██╔══╝  ██║╚██╗██║╚════██║██╔══╝  
" ██║ ╚████║╚██████╔╝██║ ╚████║███████║███████╗██║ ╚████║███████║███████╗
" ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set vb                   " disable audible bell
set novisualbell         " kill the visual bell too
set noerrorbells         " did I mention I hate bells?
set nobackup             " we have vcs, we don't need backups.
set nowritebackup        " we have vcs, we don't need backups.
set noswapfile           " annoying

" ██████╗ ██╗   ██╗███████╗███████╗███████╗██████╗ ███████╗
" ██╔══██╗██║   ██║██╔════╝██╔════╝██╔════╝██╔══██╗██╔════╝
" ██████╔╝██║   ██║█████╗  █████╗  █████╗  ██████╔╝███████╗
" ██╔══██╗██║   ██║██╔══╝  ██╔══╝  ██╔══╝  ██╔══██╗╚════██║
" ██████╔╝╚██████╔╝██║     ██║     ███████╗██║  ██║███████║
" ╚═════╝  ╚═════╝ ╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set hidden        " allow buffers with unsaved changes
set autoread      " reload files if changed on disk

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

" ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗
" ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝
" ███████║███████║██║     █████╔╝ ███████╗
" ██╔══██║██╔══██║██║     ██╔═██╗ ╚════██║
" ██║  ██║██║  ██║╚██████╗██║  ██╗███████║
" ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" execute line as shell command and replace it with output
" notice: capital Wk
noremap <leader>W !!sh<cr>

" pipe line to fmt and replace current line
noremap <F>:.!fmt --width=80<cr>

" prepend '> ' to lines as if to block quote
noremap Q :norm 0i> <esc>$

""""" noremap <leader>T !!toilet -f smblock<cr>
" noremap <leader>T !!toiletmenu -f<cr>

" view open file in rendered markdown
nmap <leader>md :!a=$(rgen) ; ghmd2html "%:p" >/tmp/$a.html && $BROWSER /tmp/$a.html<CR>

set wildignore+=*.opus,*.flac,*.mp3,*.ogg,*.mp4,*.webm
set wildignore+=*.jpg,*.png,*.gif,*.jpeg,*.pdf
set wildignore+=*.zip,*.gzip,*.bz2,*.tar,*.xz
set wildignore+=*.so,*.o,*.a

" horizontal scrolling
noremap <silent><C-o> 10zl
noremap <silent><C-i> 10zh

" print a 72-char line separator, commented
map <C-s> 72i=<ESC>:Commentary<CR>

augroup resCur "reopen vim at previous cursor point
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

" ██╗███╗   ██╗██╗   ██╗██╗███████╗██╗██████╗ ██╗     ███████╗███████╗
" ██║████╗  ██║██║   ██║██║██╔════╝██║██╔══██╗██║     ██╔════╝██╔════╝
" ██║██╔██╗ ██║██║   ██║██║███████╗██║██████╔╝██║     █████╗  ███████╗
" ██║██║╚██╗██║╚██╗ ██╔╝██║╚════██║██║██╔══██╗██║     ██╔══╝  ╚════██║
" ██║██║ ╚████║ ╚████╔╝ ██║███████║██║██████╔╝███████╗███████╗███████║
" ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚══════╝╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝
set list
set listchars=
set listchars+=tab:·\ 
set listchars+=trail:░
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:░

" ██╗   ██╗ ██████╗ ██╗███╗   ██╗██╗  ██╗
" ╚██╗ ██╔╝██╔═══██╗██║████╗  ██║██║ ██╔╝
"  ╚████╔╝ ██║   ██║██║██╔██╗ ██║█████╔╝ 
"   ╚██╔╝  ██║   ██║██║██║╚██╗██║██╔═██╗ 
"    ██║   ╚██████╔╝██║██║ ╚████║██║  ██╗
"    ╚═╝    ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
nmap <c-[> <plug>(YoinkPostPasteSwapBack)
nmap <c-]> <plug>(YoinkPostPasteSwapForward)

nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

" Also replace the default gp with yoink paste so we can toggle paste in this case too
nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)

" ██████╗  █████╗ ███╗   ██╗ ██████╗ ███████╗██████╗ 
" ██╔══██╗██╔══██╗████╗  ██║██╔════╝ ██╔════╝██╔══██╗
" ██████╔╝███████║██╔██╗ ██║██║  ███╗█████╗  ██████╔╝
" ██╔══██╗██╔══██║██║╚██╗██║██║   ██║██╔══╝  ██╔══██╗
" ██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████╗██║  ██║
" ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝
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

    let g:ranger_map_keys = 0
    nnoremap <silent><leader>r :Ranger<CR>
endif


" ███████╗██████╗ ██╗     ██╗████████╗███████╗
" ██╔════╝██╔══██╗██║     ██║╚══██╔══╝██╔════╝
" ███████╗██████╔╝██║     ██║   ██║   ███████╗
" ╚════██║██╔═══╝ ██║     ██║   ██║   ╚════██║
" ███████║██║     ███████╗██║   ██║   ███████║
" ╚══════╝╚═╝     ╚══════╝╚═╝   ╚═╝   ╚══════╝
" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

func! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfu

nnoremap <silent><C-h> :call WinMove('h')<CR>
nnoremap <silent><C-j> :call WinMove('j')<CR>
nnoremap <silent><C-k> :call WinMove('k')<CR>
nnoremap <silent><C-l> :call WinMove('l')<CR>
set fillchars+=vert:│

" open new split panes to right and bottom
" feels more natural than vim’s default
set splitbelow
set splitright

" resize split vertically
nnoremap <silent><C--> :resize -5<CR>
nnoremap <silent><C-=> :resize +5<CR>

" resize split horizontally
nnoremap <silent><C-[> :vertical resize +5<CR>
nnoremap <silent><C-]> :vertical resize -5<CR>

" allow leaving terminal mode to move between splits (LIFESAVER!)
tnoremap <silent><C-\> <C-\><C-n>

" start insert automatically when entering terminal
" (so you don't have to press 'i'), only works with neovim
if has('nvim')
    augroup nvim_terminal | au!
        " entering terminal buffer for the first time
        autocmd TermEnter term://* startinsert
        " switching to terminal window/buffer
        autocmd BufEnter term://* startinsert
    augroup end
endif

" set yank to windows clipboard, stolen from:
" https://old.reddit.com/r/vim/comments/162uzms/how_to_copy_from_vim_to_other_programwsl2_ubuntu/jy028tl
"
" this is easiest solution, no confusing plugins or different keybinds needed, just works
if system('uname -r') =~ "Microsoft"
  augroup Yank
    autocmd!
    autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
  augroup END
endif

