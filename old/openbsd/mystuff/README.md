# OpenBSD ports

## Fixing can't install ports without x11

Annoyingly OpenBSD by default spits out a message that you need X11 configured to build ports.  
On headless/server machines this isn't necessary.

To silence the message:

```
mkdir -p /usr/X11R6/man
touch /usr/X11R6/man/mandoc.db
```

