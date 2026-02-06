#!/bin/sh
#
# https://github.com/mitchweaver/gentoo
#
# removes junk that shouldn't be copied between
# installs and/or doesn't need tracked in git
# ========================================================================

[ -d portage ] || exit 1

for folder in bashrc.d package.cflags profile repos.conf savedconfig ; do
    [ -e "portage/$folder" ] && rm -rv "portage/$folder"
done

for file in bashrc make.conf.lto make.conf.lto.defines ; do
    [ -e "portage/$file" ] && rm -v "portage/$file"
done

[ -L "portage/make.profile" ] && unlink "portage/make.profile"
