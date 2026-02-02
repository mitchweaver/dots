#!/bin/sh

flatpak install flathub dev.alextren.Spot

flatpak --user override --filesystem=home:rw  \
    dev.alextren.Spot
