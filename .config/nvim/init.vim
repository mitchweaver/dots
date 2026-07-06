" ============================================
" NEOVIDE ON WINDOWS
" ============================================
if has('win32')
    set runtimepath^=C:\Users\mitch\nextcloud\src\dots\.vim
    set runtimepath+=C:\Users\mitch\nextcloud\src\dots\.vim\after
    let &packpath=&runtimepath
    source C:\Users\mitch\nextcloud\src\dots\.vimrc
else
" ============================================
" LINUX
" ============================================
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath=&runtimepath
    source ~/.vimrc
endif