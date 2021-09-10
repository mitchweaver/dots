Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y firefox
choco install -y git
choco install -y foobar2000
choco install -y steam
choco install -y obs-studio
choco install -y vcredist140
choco install -y vcredist2015
choco install -y 7zip.install
choco install -y winrar
choco install -y sysinternals
choco install -y putty.install
choco install -y ccleaner
choco install -y libreoffice-fresh
choco install -y winscp
choco install -y neovim
choco install -y wireshark
choco install -y procexp
choco install -y procmon
choco install -y processhacker
choco install -y spotify
choco install -y youtube-dl
choco install -y audacity
choco install -y ffmpeg
choco install -y psexec
choco install -y jq
choco install -y tor-browser
choco install -y rufus
choco install -y openshot
choco install -y speccy
choco install -y notepadplusplus.install
choco install -y vlc
choco install -y python3
