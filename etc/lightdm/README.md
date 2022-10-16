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

## branding

on gentoo use the `branding` USE flag for gentoo logo
