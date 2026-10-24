# annoying on boot
distrobox enter webull-ubuntu

sudo su
apt update ; apt upgrade -y
apt install -y libcurl3t64-gnutls libasound2t64 libnss3

dpkg -i webull.deb
exit
distrobox-export --app WebullDesktop
```

# GPU / Hybrid Graphics (Laptop)

To see which is card0 and which is card1

```
mitch@laptop[~] lspci | grep -E "VGA|3D"
00:02.0 VGA compatible controller: Intel Corporation Alder Lake-P GT2 [Iris Xe Graphics] (rev 0c)
01:00.0 3D controller: NVIDIA Corporation GA107M [GeForce RTX 3050 Mobile] (rev a1)
mitch@laptop[~]
```

```
mitch@laptop[~] ls -l /dev/dri/by-path/
lrwxrwxrwx@ - nobody 24 Oct 02:03 pci-0000:00:02.0-card -> ../card1
lrwxrwxrwx@ - nobody 24 Oct 02:03 pci-0000:01:00.0-card -> ../card0
mitch@laptop[~]
```

match the two together, we see 01:00.0 points to card0 and 00:02.0 points to card1

## udev rules
because these card0/card1 symlinks can swap on boot, we need to create a udev rule to force them to stay the same

```
sudo tee /etc/udev/rules.d/61-gpu-symlinks.rules <<'EOF'
SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:01:00.0", SYMLINK+="dri/nvidia-gpu"
SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:00:02.0", SYMLINK+="dri/intel-gpu"
EOF
```

reboot and afterwards you should have:
```
ls -l /dev/dri/nvidia-gpu /dev/dri/intel-gpu
```

## KDE Plasma force rendering on one card

rather than hybrid graphics only kicking in to render "heavy" applications that it thinks should be on the nvidia gpu, we can force the entire plasma session to be on it instead

```
mkdir -p ~/.config/plasma-workspace/env
echo 'export KWIN_DRM_DEVICES=/dev/dri/nvidia-gpu:/dev/dri/intel-gpu' > ~/.config/plasma-workspace/env/force_kwin_nvidia.sh
chmod +x ~/.config/plasma-workspace/env/force_kwin_nvidia.sh
```

you can verify this later with `nvidia-smi`

