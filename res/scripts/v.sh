#!/bin/sh
#
# because i get annoyed when my alias doesnt work when root
# ========================================================================

printf '%s\n%s\n' '#!/bin/sh' 'exec nvim -- "$@"' | \
sudo tee /usr/local/bin/v

sudo chmod +x /usr/local/bin/v
