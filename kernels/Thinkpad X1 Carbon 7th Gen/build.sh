#!/bin/sh

genkernel \
    --no-clean \
    --no-mrproper \
    --oldconfig \
    --menuconfig \
    --makeopts=-j"$(nproc)" \
    --no-hyperv \
    --no-virtio \
    --no-btrfs \
    --lvm \
    --luks \
    all
