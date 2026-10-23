# setup-neovide.md

## Initial setup and symlink

### NOTE: needs git and python3 installed, so first  if you haven't already:

```
choco install -y git
choco install -y python3
```

### first you probably will need to delete the default nvim folder
```
Remove-Item "C:\Users\mitch\AppData\Local\nvim" -Recurse

```

### Create symlink to the nextcloud folder, using administrative powershell:
```
New-Item -ItemType SymbolicLink -Path "C:\Users\mitch\AppData\Local\nvim" -Target "C:\Users\mitch\nextcloud\src\dots\.config\nvim"

```

### now grab Vim Plug (NON-ADMIN)
```
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
```

## Loading Python

### now make sure you have this in your .vimrc
```
if has('win32')
    " This version will need changed periodically
    let g:python3_host_prog = 'C:\Python314\python.exe'
else
    let g:python3_host_prog = '/usr/bin/python3'
endif
```

### install python neovim library
```
C:\Users\mitch>"C:\Python314\Scripts\pip.exe" install neovim
```

### Fetch plugins

in a new non-admin cmd, run:

```
nvim
:UpdateRemotePlugins
:PlugInstall
```

# Success!

Now you have neovide GUI for windows, and neovim in WSL terminal both sharing the same .vim and .vimrc

