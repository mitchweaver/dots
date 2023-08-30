#!/bin/sh

flatpak install flathub com.vscodium.codium

flatpak --user override --filesystem=home:rw \
    com.vscodium.codium
