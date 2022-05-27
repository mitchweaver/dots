#
# from the vim theme:
# https://github.com/NLKNguyen/papercolor-theme
#

case ${1#--} in
    link|l)
        ln -sf ~/src/dots/themes/"${0##*/}" ~/src/dots/themes/current
        ;;
esac

color0='#eeeeee'
color1='#af0000'
color2='#008700'
color3='#5f8700'
color4='#0087af'
color5='#878787'
color6='#005f87'
color7='#444444'
color8='#bcbcbc'
color9='#d70000'
color10='#d70087'
color11='#8700af'
color12='#d75f00'
color13='#d75f00'
color14='#005faf'
color15='#005f87'

foreground='#444444'
background='#eeeeee'
cursor='#444444'
