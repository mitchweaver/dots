# ionice

in make.conf:

```
# set ionice priority via a wrapper script
# see: https://wiki.gentoo.org/wiki/Portage_niceness#Configuration
PORTAGE_IONICE_COMMAND="/usr/local/bin/io-priority \${PID}"
```

## note

I don't think this is worth using if you have fast (nvme) storage
