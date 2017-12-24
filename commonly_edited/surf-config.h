#include "surf-configh-ignore.h"
#define HOMEPAGE "/home/mitch/workspace/dotfiles/startpage/index.html"
static char *searchengine = "https://duckduckgo.com/html/?q=";
static SearchEngine searchengines[] = {
         { "d",      "https://duckduckgo.com/html/?q=%s" },
         { "g",      "https://encrypted.google.com/search?q=%s"   },
         { "git",    "https://github.com/search?utf8=&q=%s&type=" },
         { "wiki",   "https://en.wikipedia.org/wiki/%s" },
         { "metal",  "http://www.metal-archives.com/search?searchString=%s&type=band_name" },
         { "arch",   "https://wiki.archlinux.org/index.php?search=%s" },
         { "gentoo", "https://wiki.gentoo.org/index.php?search=%s" },
         { "r",      "https://reddit.com/r/%s" },
         { "4",      "https://boards.4chan.org/%s" },
         { "yt",     "https://youtube.com/results?search_query=%s" },
         { "image",  "https://www.google.com/search?safe=active&tbm=isch&q=%s" },
         { "reddit", "https://reddit.com/search?q=%s" },
};

static UriParameters uriparams[] = {
    /* { "(://|\\.)duckduckgo\\.com(/|$)", { [JavaScript] = { { .i = 0 }, 1 }, }, }, */
};

#define PROMPT_GO   "Go:"
#define PROMPT_FIND "Find:"

/* DOWNLOAD(URI, referer) */
// This sets all the ids for the opening terminal to 'curl'.
// This way you can set that 'curl' terminal to be opened floating
// Which stops the annoying flashing/moving around of windows on a download.
#define DOWNLOAD(u, r) { \
        .v = (const char *[]){ "st", "-T", "surf-download", "-n", "surf-download", "-e", \
            "/bin/sh", "-c", "cd ~/downloads && curl -g -L -O $@ && exit", \
             "surf-download", u, r, NULL \
        } \
}

/* This called when some URI which does not begin with "about:",
 * "http://" or "https://" should be opened. */
#define PLUMB(u) {\
        .v = (const char *[]){ "/bin/sh", "-c", \
             "xdg-open \"$0\"", u, NULL \
        } \
}

#define VIDEOPLAY(u) {\
        .v = (const char *[]){ "/bin/sh", "-c", \
             "mpv --really-quiet \"$0\"", u, NULL \
        } \
}

static SiteSpecific styles[] = {
	/* regexp               file in $styledir */
	{ ".*",                 "default.css" },
};

/* ------- BOOK MARKING --------------------------------- */
#define BM_PICK { .v = (char *[]){ "/bin/sh", "-c", \
    "xprop -id $0 -f _SURF_GO 8s -set _SURF_GO \
    `cat ~/.surf/bookmarks | dmenu -i -l 15 || exit 0`", \
    winid, NULL } }

#define BM_ADD { .v = (char *[]){ "/bin/sh", "-c", \
    "(echo `xprop -id $0 _SURF_URI | cut -d '\"' -f 2` && \
    cat ~/.surf/bookmarks) | sort -u > ~/.surf/bookmarks_new && \
    mv ~/.surf/bookmarks_new ~/.surf/bookmarks", \
    winid, NULL } }
/* ------------------------------------------------------ */

/* ------------------- GO HOME -------------------------- */
#define GO_HOME { .v = (char *[]){ "/bin/sh", "-c", \
    "xprop -id $0 -f _SURF_GO 8s -set _SURF_GO \
    /home/mitch/workspace/dotfiles/startpage/index.html || exit 0", \
    winid, NULL } }
/* ---------------------------------------------------- */

/* ----------- open flash videos with youtube-dl ------------ */
#define YOUTUBEDL {.v = (char *[]){ "/bin/sh", "-c", \
        "mpv --really-quiet $(xprop -id $0 _SURF_URI | cut -d \\\" -f 2) &", \
        winid, NULL } }
/* ----------------------------------------------------------------- */

/* --------- function to launch arbitrary commands ---------------- */
#define SH(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
/* -------------------------------------------------------------------------- */

// The complete list of gdk key syms can be found at:
// http://git.gnome.org/browse/gtk+/plain/gdk/gdkkeysyms.h
#define MODKEY GDK_CONTROL_MASK
#define SHIFT GDK_SHIFT_MASK
static Key keys[] = {
    { MODKEY,               GDK_KEY_g,       spawn,      SETPROP("_SURF_URI", "_SURF_GO", PROMPT_GO) },
    { MODKEY,               GDK_KEY_slash,   spawn,      SETPROP("_SURF_FIND", "_SURF_FIND", PROMPT_FIND) },
    { MODKEY,               GDK_KEY_period,  find,       { .i = +1 } },
    { MODKEY,               GDK_KEY_comma,   find,       { .i = -1 } },
    { MODKEY,               GDK_KEY_r,       reload,     { .i = 0 } },
    { 0,                    GDK_KEY_F5,      reload,     { .i = 0 } },
    { 0,                    GDK_KEY_Escape,  stop,       { 0 } },
    { MODKEY,               GDK_KEY_c,       stop,       { 0 } },

    /* ----------------- Custom Functions ---------------------------- */
    { MODKEY,               GDK_KEY_o,      spawn,      YOUTUBEDL },
    { MODKEY,               GDK_KEY_b,      spawn,      BM_PICK },
    { MODKEY|SHIFT,         GDK_KEY_b,      spawn,      BM_ADD },
    { MODKEY,               GDK_KEY_t,      spawn,      SH("python ~/workspace/dotfiles/suckless-tools/surf/scripts-surf/surf-translate.py '$(xclip -o)'") },
    { MODKEY,               GDK_KEY_space,  spawn,      GO_HOME  },
    /* ----------------- End Custom Functions ------------------------ */

    /* ---------------------- History -------------------------------- */
    { MODKEY,               GDK_KEY_apostrophe,  navigate,   { .i = +1 } },
    { MODKEY,               GDK_KEY_semicolon,   navigate,   { .i = -1 } },
    /* --------------------------------------------------------------- */

    /* -------------------- Zooming -------------------------------------- */
    { MODKEY,                GDK_KEY_minus,       zoom,       { .i = -1 } },
    { MODKEY,                GDK_KEY_plus,        zoom,       { .i = +1 } },
    { MODKEY,                GDK_KEY_equal,       zoom,       { .i = +1 } },
    { MODKEY,                GDK_KEY_BackSpace,   zoom,       { .i = +0 } },
    { 0,                     GDK_KEY_F11,         togglefullscreen, { 0 } },
    /* ------------------------------------------------------------------- */

    // vim mode
    { MODKEY,               GDK_KEY_j,      scroll,     { .i = 'd' } },
    { MODKEY,               GDK_KEY_k,      scroll,     { .i = 'u' } },
    { MODKEY,               GDK_KEY_l,      scroll,     { .i = 'r' } },
    { MODKEY,               GDK_KEY_h,      scroll,     { .i = 'l' } },
    /* these conflict with other binds ---- figure out later */
    /* { MODKEY,               GDK_KEY_f,      scroll,     { .i = 'U' } }, */
    /* { MODKEY,               GDK_KEY_b,      scroll,     { .i = 'D' } }, */

    /* --------------------- Toggles -------------------------------------- */
    { MODKEY|SHIFT,          GDK_KEY_s,      toggle,     { .i = JavaScript } },
    { MODKEY,                GDK_KEY_i,      toggle,     { .i = LoadImages } },
    /* { MODKEY,                GDK_KEY_m,      toggle,     { .i = Style } }, */
    // what is frame flattening exactly?
    /* { MODKEY|SHIFT, GDK_KEY_f,      toggle,     { .i = FrameFlattening } }, */
    // i dont have any plugins?
    /* { MODKEY|SHIFT, GDK_KEY_v,      toggle,     { .i = Plugins } }, */
    /* -------------------------------------------------------------------- */

    // Uncomment this if you want printing
    /* { MODKEY,                GDK_KEY_p,      print,      { 0 } }, */

    // just let your system clipboard handle it
    /* { MODKEY,                GDK_KEY_p,      clipboard,  { .i = 1 } }, */
    /* { MODKEY,                GDK_KEY_v,      clipboard,  { .i = 1 } }, */
    /* { MODKEY,                GDK_KEY_y,      clipboard,  { .i = 0 } }, */
    /* { MODKEY,                GDK_KEY_c,      clipboard,  { .i = 0 } }, */

    // Inspector doesn't work for me, don't know why.
    /* { 0,                     GDK_KEY_F12,      toggleinspector, { 0 } }, */
};

/* target can be OnDoc, OnLink, OnImg, OnMedia, OnEdit, OnBar, OnSel, OnAny */
static Button buttons[] = {
	/* target       event mask      button  function        argument        stop event */
	{ OnLink,       0,              2,      clicknewwindow, { .i = 0 },     1 },
	{ OnLink,       MODKEY,         2,      clicknewwindow, { .i = 1 },     1 },
	{ OnLink,       MODKEY,         1,      clicknewwindow, { .i = 1 },     1 },
	{ OnAny,        0,              8,      clicknavigate,  { .i = -1 },    1 },
	{ OnAny,        0,              9,      clicknavigate,  { .i = +1 },    1 },
	{ OnMedia,      MODKEY,         1,      clickexternplayer, { 0 },       1 },
};
