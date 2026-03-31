#!/bin/sh

TULSA='36.2:-96.0'

# DEFAULT_HIGH=6500
# DEFAULT_LOW=4500

HIGH=6400
LOW=5000

exec gammastep -P -t "$HIGH:$LOW" -l "$TULSA" >~/.cache/gammastep.log 2>&1

