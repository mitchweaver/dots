#!/bin/sh

if [ "$CONTAINER_ID" ] ; then
    >&2 echo "you're in distrobox idiot"
    exit 1
fi

# ========================================================================
# files
# ========================================================================
sudo install -Dvm 0644 ./tlp.conf                                         /etc/tlp.conf
sudo install -Dvm 0644 ./fail2ban/jail.local                              /etc/fail2ban/jail.local
sudo install -Dvm 0644 ./modprobe.d/*conf                                 /etc/modprobe.d
sudo insatll -Dvm 0644 ./NetworkManager/conf.d/wifi-powersave.conf        /etc/NetworkManager/conf.d/wifi-powersave.conf
sudo install -Dvm 0644 ./sysctl.d/*conf                                   /etc/sysctl.d
sudo install -Dvm 0644 ./systemd/coredump.conf.d/disable.conf             /etc/systemd/coredump.conf.d/disable.conf
sudo install -Dvm 0644 ./systemd/zram-generator.conf                      /etc/systemd/zram-generator.conf
sudo install -Dvm 0644 ./udev/rules.d/70-wooting.rules                    /etc/udev/rules.d/70-wooting.rules
sudo install -Dvm 0644 ./udev/rules.d/42-logitech-unify-permissions.rules /etc/udev/rules.d/42-logitech-unify-permissions.rules

# ========================================================================
# load udev changes
# ========================================================================
# sudo udevadm control --reload-rules
# sudo udevadm trigger

# ========================================================================
# /etc/rc.local
# ========================================================================
if [ ! -e /etc/rc.local ] ; then
    old_dir="$PWD"
    cd /tmp
    git clone https://github.com/mitchweaver/rclocal
    cd rclocal
    sudo make install
    cd "$old_dir"
    sudo install -Dvm 0755 ./rc.local /etc/rc.local
fi

# ========================================================================
# load files and restart services
# ========================================================================
sudo systemctl restart tlp
sudo systemctl restart fail2ban
sudo sysctl --system

