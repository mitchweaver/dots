# WSL Setup

```
# set password
wsl -d <distro-name> -u root

# change shell
dnf install -y oksh
chsh -s $(which oksh)
```


cd ~

ln -s /mnt/c/Users/mitch/MEGA cloud

ln -s /home/mitch/cloud/src
ln -s /home/mitch/cloud/files
ln -s /home/mitch/cloud/images


# ========================

mkdir -p ~/.config

ln -s ~/src/dots/.gitconfig
ln -s ~/src/dots/.cvsrc
ln -s ~/src/dots/.detoxrc
ln -s ~/src/dots/.gitignore_global
ln -s ~/src/dots/.profile
ln -s ~/src/dots/.pylintrc
ln -s ~/src/dots/.shellcheckrc
ln -s ~/src/dots/.vimrc
ln -s ~/src/dots/.wgetrc

ln -s ~/src/dots/.config/nvim ~/.config/nvim
ln -s ~/src/dots/.config/ranger ~/.config/ranger


# fix dnf not being able to search as non-root
sudo chmod 644 /usr/lib/sysimage/libdnf5/*.toml


# /tmp

size grows as is used

```
echo "tmpfs /tmp tmpfs rw,noatime,nosuid,nodev,size=4G" >> /etc/fstab
```

