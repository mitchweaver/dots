#!/bin/sh

sudo install -Dvm 0644 jail.local /etc/fail2ban/jail.local

sudo systemctl enable fail2ban
sudo systemctl start fail2ban


