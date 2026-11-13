" ============================================
" NEOVIDE ON WINDOWS
" ============================================
if has('win32')
    set runtimepath^=C:\Users\mitch\MEGA\src\dots\.vim
    set runtimepath+=C:\Users\mitch\MEGA\src\dots\.vim\after
    let &packpath=&runtimepath
    source C:\Users\mitch\MEGA\src\dots\.vimrc
else
" ============================================
" LINUX
" ============================================
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath=&runtimepath
    source ~/.vimrc
endif