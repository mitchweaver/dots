#!/usr/bin/env sh
# ranger supports enhanced previews.  If the option "use_preview_script"
# is set to True and this file exists, this script will be called and its
# output is displayed in ranger.  ANSI color codes are supported.

# NOTES: This script is considered a configuration file.  If you upgrade
# ranger, it will be left untouched. (You must update it yourself.)
# Also, ranger disables STDIN here, so interactive scripts won't work properly

# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | success. display stdout as preview
# 1    | no preview | failure. display no preview at all
# 2    | plain text | display the plain content of the file
# 3    | fix width  | success. Don't reload when width changes
# 4    | fix height | success. Don't reload when height changes
# 5    | fix both   | success. Don't ever reload
# 6    | image      | success. display the image $cached points to as an image preview
# 7    | image      | success. display the file directly as an image

# Meaningful aliases for arguments:
path="$1"            # Full path of the selected file
width="$2"           # Width of the preview pane (number of fitting characters)
height="$3"          # Height of the preview pane (number of fitting characters)
cached="$4"          # Path that should be used to cache image previews
preview_images="$5"  # "True" if image previews are enabled, "False" otherwise.

maxln=200    # Stop after $maxln lines.  Can be used like ls | head -n $maxln

# Find out something about the file:
mimetype=$(file --mime-type -Lb "$path")
extension=$(/bin/echo "${path##*.}" | awk '{print tolower($0)}')

# Functions:
# runs a command and saves its output into $output.  Useful if you need
# the return value AND want to use the output in a pipe
try() { output=$(eval '"$@"'); }

# writes the output of the previously used "try" command
dump() { /bin/echo "$output"; }

# a common post-processing function used after most commands
trim() { head -n "$maxln"; }

# wraps highlight to treat exit code 141 (killed by SIGPIPE) as success
safepipe() { "$@"; test $? = 0 -o $? = 141; }

if [ "$preview_images" = "True" ]; then
    case "$mimetype" in
        # Image previews for image files. w3mimgdisplay will be called for all
        video/* | image/*)
            exit 7;;
        video/*)
            # ffmpeg -loglevel quiet -i "$path" -f mjpeg -t 0.0001 -ss 0 -y "$cached" && exit 6;;
            ffmpeg -loglevel panic -y -i "$path"  -r 0.0033 -vf scale=-1:240 -vcodec png "$cached" ; exit 6;;
            # ffmpeg -ss 3 -i "$path"-vf "select=gt(scene\,0.4)" -frames:v 5 -vsync vfr -vf fps=fps=1/600 "$cached" > /dev/null ; exit 6;;
    esac
fi

case "$extension" in
    # PDF documents:
    # pdf)
        # try pdftoppm -jpeg -singlefile "${FILE_PATH}" "${IMAGE_CACHE_PATH//.jpg}" && exit 6
        # try pdftotext -l 10 -nopgbrk -q "$path" - && \
        #     { dump | trim | fmt -s -w $width; exit 0; } || exit 1;;
    # md|markdown|markd)
    # BitTorrent Files
    # torrent)
        # try transmission-show "$path" && { dump | trim; exit 5; } || exit 1;;
    # HTML Pages:
    # htm|html|xhtml)
        # try w3m    -dump "$path" && { dump | trim | fmt -s -w $width; exit 4; }
        # ;; # fall back to highlight/cat if the text browsers fail
esac

case "$mimetype" in
    text/* | */xml |*/diff | */sh | */bash | */ksh )
        if [ "$(tput colors)" -ge 256 ]; then
            # pygmentize_format=terminal256
            # highlight_format=xterm256

            pygmentize_format=st-256color
            highlight_format=st-256color

        else
            pygmentize_format=terminal
            highlight_format=ansi
        fi
        try safepipe highlight --out-format=${highlight_format} "$path" && { dump | trim; exit 5; }
        try safepipe pygmentize -f ${pygmentize_format} "$path" && { dump | trim; exit 5; }
        exit 2;;
    # Display information about media files:
    # video/* | audio/*)
    audio/*)
        # Use sed to remove spaces so the output fits into the narrow window
        try mediainfo "$path" && { dump | trim | sed 's/  \+:/: /;';  exit 5; } || exit 1;;
esac

exit 1
