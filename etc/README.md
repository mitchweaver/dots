# /etc

System files for OpenBSD

Some various notes below:

## `$ /etc/login.conf`

Add your user to the "staff" group:

`$ usermod -G staff mitch`

this group has fewer restrictions on processes  
(however it doesn't grant any less secure priviledges...)

Also edit /etc/login.conf and change "datasize-cur=XXXXM"
to a higher value, (example: 75% of your total ram on your machine.)

## `$ /etc/fstab`

Using 'softdep' and 'noatime' can greatly improve performance,  
but they cannot be used on top-level root

```
???.e /var ffs rw,nodev,nosuid,softdep,noatime 1 2
```

Create a tmpfs on /tmp, (mfs is a OpenBSD's tmpfs)

```
# note: this is for 500MB
swap /tmp mfs rw,nodev,nosuid,-s=500m 0 0
```

The permissions of /tmp should be fixed before mounting it,  
meaning /tmp on root should be changed to 1777

```
umount /tmp
chmod 1777 /tmp
mount /tmp
```

## `$ /etc/hostname.trunk0`

Trunks are virtual interfaces consisting of one or more network interfaces.  
Here we will trunk our wired interface `em0` along with two wireless
interfaces `iwn0` and `urtwn0`.

Now any of the three will be used in fail-over, but the em0
will be prioritized if available as its listed first. Easy!

```
$ /etc/hotsname.trunk0
up
trunkproto failover trunkport em0
trunkport urtwn0
trunkport iwn0
-inet6
dhcp
```
