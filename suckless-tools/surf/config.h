static char *scriptfile     = "~/.surf/script.js";
static char *styledir       = "~/.surf/styles/";
static char *certdir        = "~/.surf/certificates/";
static char *cachedir       = "~/.surf/cache/";
static char *cookiefile     = "~/.surf/cookies.txt";
static char *historyfile    = "~/.surf/history.txt";

#define HOMEPAGE "/home/mitch/workspace/dotfiles/startpage/index.html"

/* default search provider */
static char *searchengine = "https://duckduckgo.com/html/?q=";
static SearchEngine searchengines[] = {
         { "d",  "https://duckduckgo.com/html/?q=%s" },
         { "g",   "https://google.com/search?q=%s"   },
         { "git", "https://github.com/search?utf8=&q=%s&type=" },
         { "wiki", "https://en.wikipedia.org/wiki/%s" },
         { "metal", "http://www.metal-archives.com/search?searchString=%s&type=band_name" },
         { "arch", "https://wiki.archlinux.org/index.php?search=%s" },
         { "gentoo", "https://wiki.gentoo.org/index.php?search=%s" },
         { "r", "https://reddit.com/r/%s" },
         { "4", "https://boards.4chan.org/%s" },
};

/* Highest priority value will be used.
 * Default parameters are priority 0
 * Per-uri parameters are priority 1
 * Command parameters are priority 2 */
static Parameter defconfig[ParameterLast] = {
	/* parameter                    Arg value       priority */
	[AcceleratedCanvas]   =       { { .i = 1 },     },
            // -------------------------- //
	[AccessMicrophone]    =       { { .i = 0 },     },
	[AccessWebcam]        =       { { .i = 0 },     },
            // -------------------------- //
	[Certificate]         =       { { .i = 0 },     },
	[CaretBrowsing]       =       { { .i = 0 },     },
	[CookiePolicies]      =       { { .v = "@Aa" }, },
	[DefaultCharset]      =       { { .v = "UTF-8" }, },
	[DiskCache]           =       { { .i = 1 },     },

	[DNSPrefetch]         =       { { .i = 0 },     },
	[FontSize]            =       { { .i = 12 },    },
	[ZoomLevel]           =       { { .f = 1.2 },   },

	[FileURLsCrossAccess] =       { { .i = 1 },     },
	[FrameFlattening]     =       { { .i = 0 },     }, // what does this do?
	[Geolocation]         =       { { .i = 0 },     },
	[HideBackground]      =       { { .i = 0 },     },
	[Inspector]           =       { { .i = 0 },     },
	[Java]                =       { { .i = 0 },     }, // LOLSECURITY?
	[JavaScript]          =       { { .i = 1 },     },
	[KioskMode]           =       { { .i = 0 },     },
	[LoadImages]          =       { { .i = 1 },     },
	[MediaManualPlay]     =       { { .i = 1 },     },
	[Plugins]             =       { { .i = 1 },     }, // what are plugins?
	[PreferredLanguages]  =       { { .v = (char *[]){ NULL } }, },
	[RunInFullscreen]     =       { { .i = 0 },     },
	[ScrollBars]          =       { { .i = 0 },     }, // FUCK SCROLLBARS
	[ShowIndicators]      =       { { .i = 0 },     }, // letters at the start
	[SiteQuirks]          =       { { .i = 1 },     },
	[SmoothScrolling]     =       { { .i = 1 },     },
	[SpellChecking]       =       { { .i = 0 },     }, // Who needs this, really?
	[SpellLanguages]      =       { { .v = ((char *[]){ "en_US", NULL }) }, },
	[StrictTLS]           =       { { .i = 1 },     },
	[Style]               =       { { .i = 1 },     },
};

static UriParameters uriparams[] = {
    /* { "(://|\\.)duckduckgo\\.com(/|$)", { */
	    /* [JavaScript] = { { .i = 0 }, 1 }, */
	/* }, }, */
};

static WebKitFindOptions findopts = WEBKIT_FIND_OPTIONS_CASE_INSENSITIVE |
                                    WEBKIT_FIND_OPTIONS_WRAP_AROUND;

#define PROMPT_GO   "Go:"
#define PROMPT_FIND "Find:"

/* SETPROP(readprop, setprop, prompt)*/
#define SETPROP(r, s, p) { \
        .v = (const char *[]){ "/bin/sh", "-c", \
             "prop=\"$(printf '%b' \"$(xprop -id $1 $2 " \
             "| sed \"s/^$2(STRING) = //;s/^\\\"\\(.*\\)\\\"$/\\1/\")\" " \
             "| dmenu -p \"$4\" -w $1)\" && xprop -id $1 -f $3 8s -set $3 \"$prop\"", \
             "surf-setprop", winid, r, s, p, NULL \
        } \
}

/* DOWNLOAD(URI, referer) */
// This sets all the ids for the opening terminal to 'curl'.
// This way you can set that 'curl' terminal to be opened floating
// Which stops the annoying flashing/moving around of windows on a download.
#define DOWNLOAD(u, r) { \
        .v = (const char *[]){ "st", "-T", "surf-download",  "-w", "surf-download", "-n", "surf-download", "-e", "/bin/sh", "-c", \
             "cd ~/downloads && curl -g -L -O $@ && exit", \
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

/* button definitions */
/* target can be OnDoc, OnLink, OnImg, OnMedia, OnEdit, OnBar, OnSel, OnAny */
static Button buttons[] = {
	/* target       event mask      button  function        argument        stop event */
	{ OnLink,       MODKEY,         1,      clicknewwindow, { .i = 1 },     1 },
	{ OnLink,       0,              2,      clicknewwindow, { .i = 0 },     1 },
	{ OnLink,       MODKEY,         2,      clicknewwindow, { .i = 1 },     1 },
    // this is really buggy, use the ctrl-o bind instead
	/* { OnMedia,      MODKEY,         1,      clickexternplayer, { 0 },       1 }, */
};


/* -------------- IGNORE ------------------------ */
static SiteSpecific certs[] = {{"://ewioajeowidfaweoijfdsf\\.org/", "ewioajeowidfaweoijfdsf.org.crt" },};
static int surfuseragent    = 0;
static int winsize[] = { 1280, 800 };
static char *fulluseragent  = "";
