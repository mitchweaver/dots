#!/bin/sh

if ! command -v brew >/dev/null ; then
	>&2 echo install brew dummy
	exit 1
fi

brew install \
aria2 bash bash-completion bdw-gc brotli c-ares ca-certificates detox docbook docbook-xsl docker docker-compose exa fail2ban fontconfig \
freetype fribidi gawk gdbm gettext ghostscript giflib git glib gmp gnu-getopt gnutls gotop guile htop imagemagick imath imlib2 ipmitool \
jbig2dec jpeg jpeg-xl jpegoptim jq libcaca libde265 libevent libffi libgcrypt libgpg-error libheif libidn libidn2 liblqr libmaxminddb \
libnghttp2 libomp libpng libpthread-stubs libsmi libssh libssh2 libtasn1 libtermkey libtiff libtool libunistring libuv libvmaf libx11 \
libxau libxcb libxdmcp libxext little-cms2 lolcat lua luajit-openresty luv lz4 m4 mpdecimal mpfr msgpack ncurses neofetch neovim neovim-qt \
netcat nettle nmap oksh oniguruma openexr openjpeg openssl@1.1 p11-kit p7zip pcre pcre2 pkg-config popt pv pylint python@3.10 python@3.9 \
qt@5 ranger readline rlwrap rsync screenresolution shared-mime-info sqlite toilet translate-shell tree-sitter unbound unibilium unzip \
watch webp wget x265 xmlto xorgproto xxhash xz youtube-dl zip zstd alt-tab balenaetcher deadbolt displaylink displaylink-login-extension \
firefox-nightly font-terminus gimp google-chrome mpv obs openshot-video-editor shotcut signal spotify tor-browser-alpha tradingview \
transmission wireshark zoom
