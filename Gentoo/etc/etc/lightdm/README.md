# lightdm

## to run ~/.xinitrc

Need to create a session file  
Use: https://github.com/mitchweaver/xinitrc-as-xsession

## drop priv

This is NOT default in lightdm.conf

```
greeter-user=lightdm
```

## to autologin

```
autologin-user = mitch
autologin-user-timeout = 0
```

------

# Gentoo

## init.d service

Remember to install `display-manager-init` and enable the service

Then set `/etc/conf.d/display-manager` to be lightdm

## branding

on Gentoo use the `branding` USE flag for gentoo logo
