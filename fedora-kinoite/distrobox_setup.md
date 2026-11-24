## distrobox

### setting up the container

```
# NOTE: if requiring nvidia drivers in the container, need to pass the --nvidia flag
#       however this wont work for alpine due to glibc/musl
distrobox create \
    --name alpine \
    --image alpine:latest \
    --unshare-ipc

distrobox enter alpine
```

### repositories

```
sudo su

# bind /mnt to the host's /mnt
rmdir /mnt
ln -s /run/host/mnt /mnt

# update all containers
cat > /etc/apk/repositories <<"EOF"
https://dl-cdn.alpinelinux.org/alpine/edge/main
https://dl-cdn.alpinelinux.org/alpine/edge/community
https://dl-cdn.alpinelinux.org/alpine/edge/testing
EOF

apk update
apk upgrade
```

### packages

```
apk add \
    docs coreutils binutils findutils util-linux pciutils usbutils \
    grep gawk iproute2 bc htop gotop lsof lm-sensors lm-sensors-detect \
    smartmontools sysstat upower git \
    openssl libnotify libsecret nlohmann-json \
    p7zip unzip zip lz4 xz lzo gzip pigz \
    rsync openresolv netcat-openbsd nmap bind-tools socat ldns \
    wireless-tools speedtest-cli \
    entr detox dos2unix inotify-tools dateutils libqrencode \
    w3m w3m-image py3-pillow py3-pillow_heif lynx \
    oksh neovim translate-shell tree pv progress eza bat py3-pynvim ncdu \
    pfetch fastfetch kitty-terminfo \
    build-base gcc patch musl-dev meson ninja shellcheck jq py3-pylint hugo sassc \
    linux-headers ncurses-dev openssl-dev elfutils-dev \
    ffmpeg imagemagick jpegoptim exiftool cuetools shntool vorbis-tools \
    wavpack mpv yt-dlp \
    py3-setuptools py3-numpy py3-scipy
```

## misc

#### RANGER

current releases of ranger is broken with ncurses and maintainer is taking forever to make a new release

```
cd /tmp
git clone https://github.com/ranger/ranger
cd ranger
sudo make install
```

