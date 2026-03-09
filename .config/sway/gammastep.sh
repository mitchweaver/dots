#!/bin/sh

TULSA='36.2:-96.0'

DEFAULT_HIGH=6500
DEFAULT_LOW=4500

exec gammastep -P -t 6300:4900 -l "$TULSA" >~/.cache/gammastep.log 2>&1

