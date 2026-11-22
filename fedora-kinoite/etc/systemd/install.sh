#!/bin/sh

sudo install -Dvm 0644 coredump.conf.d/disable.conf /etc/systemd/coredump.conf.d/disable.conf
sudo install -Dvm 0644 zram-generator.conf /etc/systemd/zram-generator.conf

