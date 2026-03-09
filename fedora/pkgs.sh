dnf config-manager addrepo --from-repofile=https://repo.librewolf.net/librewolf.repo
dnf install librewolf

# swayfx
dnf copr enable swayfx/swayfx
dnf install -y swayfx

# mailspring -- get .rpm
dnf install -y libtidy

# joplin
dnf copr enable taw/joplin
dnf install -y joplin

# bitwarden --- get .rpm
# https://bitwarden.com/download/#downloads-desktop

# mullvad
dnf config-manager addrepo --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo
dnf install mullvad-vpn

# ========================================================================
# DEV LIBS
# ========================================================================
apk add libX11-devel ncurses-devel libXinerama-devel libXft-devel \
    elfutils-devel openssl-devel


NetworkManager-tui

# for images in kitty
python3-pillow

# ========================================================================
# DEVELOPMENT
# ========================================================================
ollama jq java-latest-openjdk ShellCheck pylint hugo pandoc

# ========================================================================
# security
# ========================================================================
binwalk
