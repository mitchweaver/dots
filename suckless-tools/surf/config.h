static char *fulluseragent  = ""; /* Or override the whole user agent string */
static char *scriptfile     = "~/.surf/script.js";
static char *styledir       = "~/.surf/styles/";
static char *certdir        = "~/.surf/certificates/";
static char *cachedir       = "~/.surf/cache/";
static char *cookiefile     = "~/.surf/cookies.txt";
static char *historyfile    = "~/.surf/history.txt";



/* default search provider */
static char *searchengine = "https://duckduckgo.com/html/?q="; 
static SearchEngine searchengines[] = {
        { "d",  "https://duckduckgo.com/html/?q=%s" },
        { "g",   "https://google.com/search?q=%s"   },
        { "arch", "https://wiki.archlinux.org/index.php?search=%s" },
        { "gentoo", "https://wiki.gentoo.org/index.php?search=%s" },
        { "r", "https://reddit.com/r/%s" },
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
	[DNSPrefetch]         =       { { .i = 1 },     },
	[FileURLsCrossAccess] =       { { .i = 0 },     },
	[FontSize]            =       { { .i = 12 },    },
	[FrameFlattening]     =       { { .i = 0 },     },
	[Geolocation]         =       { { .i = 0 },     },
	[HideBackground]      =       { { .i = 0 },     },
	[Inspector]           =       { { .i = 0 },     },
	[Java]                =       { { .i = 0 },     }, // LOLSECURITY?
	[JavaScript]          =       { { .i = 1 },     },
	[KioskMode]           =       { { .i = 0 },     },
	[LoadImages]          =       { { .i = 1 },     },
	[MediaManualPlay]     =       { { .i = 1 },     },
	[Plugins]             =       { { .i = 1 },     },
	[PreferredLanguages]  =       { { .v = (char *[]){ NULL } }, },
	[RunInFullscreen]     =       { { .i = 0 },     },
	[ScrollBars]          =       { { .i = 0 },     }, // FUCK SCROLLBARS
	[ShowIndicators]      =       { { .i = 0 },     }, // letters at the start
	[SiteQuirks]          =       { { .i = 1 },     },
	[SmoothScrolling]     =       { { .i = 1 },     }, // TESTING 
	[SpellChecking]       =       { { .i = 0 },     }, // Who needs this, really?
	[SpellLanguages]      =       { { .v = ((char *[]){ "en_US", NULL }) }, },
	[StrictTLS]           =       { { .i = 1 },     },
	[Style]               =       { { .i = 1 },     },
	[ZoomLevel]           =       { { .f = 1.4 },   },
};

static UriParameters uriparams[] = {
	{ "(://|\\.)suckless\\.org(/|$)", {
	  [JavaScript] = { { .i = 0 }, 1 },
	  [Plugins]    = { { .i = 0 }, 1 },
	}, },
};


static WebKitFindOptions findopts = WEBKIT_FIND_OPTIONS_CASE_INSENSITIVE |
                                    WEBKIT_FIND_OPTIONS_WRAP_AROUND;

#define PROMPT_GO   "Go:"
#define PROMPT_FIND "Find:"


#define HOMEPAGE "https://duckduckgo.com/html"


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
#define DOWNLOAD(u, r) { \
        .v = (const char *[]){ "st", "-e", "/bin/sh", "-c",\
             "cd /home/mitch/downloads && curl -g -L -O $1 && exit", \
             "surf-download", u, r, NULL \
        } \
}

/* This called when some URI which does not begin with "about:",
 * "http://" or "https://" should be opened.
 */
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

/* styles */
/*
 * The iteration will stop at the first match, beginning at the beginning of
 * the list.
 */
static SiteSpecific styles[] = {
	/* regexp               file in $styledir */
	{ ".*",                 "default.css" },
};

 /* ------- BOOK MARKING ---------------- */
#define BM_PICK { .v = (char *[]){ "/bin/sh", "-c", \
    "xprop -id $0 -f _SURF_GO 8s -set _SURF_GO \
    `cat ~/.surf/bookmarks | dmenu || exit 0`", \
    winid, NULL } }

#define BM_ADD { .v = (char *[]){ "/bin/sh", "-c", \
    "(echo `xprop -id $0 _SURF_URI | cut -d '\"' -f 2` && \
    cat ~/.surf/bookmarks) | sort -u > ~/.surf/bookmarks_new && \
    mv ~/.surf/bookmarks_new ~/.surf/bookmarks", \
    winid, NULL } }
/* ----------------------------------------- */


/* ----------- open flash videos with youtube-dl ------------ */
#define YOUTUBEDL {.v = (char *[]){ "/bin/sh", "-c", \
        "mpv --really-quiet $(xprop -id $0 _SURF_URI | cut -d \\\" -f 2) &", \
        winid, NULL } }
/* ----------------------------------------------------------------- */


#define MODKEY GDK_CONTROL_MASK
/* hotkeys */
/*
 * If you use anything else but MODKEY and GDK_SHIFT_MASK, don't forget to
 * edit the CLEANMASK() macro.
 */
static Key keys[] = {
	/* modifier              keyval          function    arg */
	{ MODKEY,                GDK_KEY_g,      spawn,      SETPROP("_SURF_URI", "_SURF_GO", PROMPT_GO) },
	{ 0,                     GDK_KEY_slash,  spawn,      SETPROP("_SURF_FIND", "_SURF_FIND", PROMPT_FIND) },

	{ 0,                     GDK_KEY_Escape, stop,       { 0 } },
	{ MODKEY,                GDK_KEY_c,      stop,       { 0 } },


    { MODKEY,               GDK_KEY_o,      spawn,      YOUTUBEDL },

    { MODKEY,               GDK_KEY_b,      spawn,      BM_PICK },
    { MODKEY|GDK_SHIFT_MASK,GDK_KEY_b,      spawn,      BM_ADD },

	{ MODKEY,                GDK_KEY_r,      reload,     { .i = 0 } },

	{ MODKEY,                GDK_KEY_l,      navigate,   { .i = +1 } },
	{ MODKEY,                GDK_KEY_h,      navigate,   { .i = -1 } },

	/* Currently we have to use scrolling steps that WebKit2GTK+ gives us
	 * d: step down, u: step up, r: step right, l:step left * D: page down, U: page up */ 
    { MODKEY,                GDK_KEY_j,      scroll,     { .i = 'd' } },
	{ MODKEY,                GDK_KEY_k,      scroll,     { .i = 'u' } },
	{ MODKEY,                GDK_KEY_b,      scroll,     { .i = 'U' } },
	{ MODKEY,                GDK_KEY_space,  scroll,     { .i = 'D' } },
	{ MODKEY,                GDK_KEY_i,      scroll,     { .i = 'r' } },
	{ MODKEY,                GDK_KEY_u,      scroll,     { .i = 'l' } },


	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_j,      zoom,       { .i = -1 } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_k,      zoom,       { .i = +1 } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_q,      zoom,       { .i = 0  } },
	{ MODKEY,                GDK_KEY_minus,  zoom,       { .i = -1 } },
	{ MODKEY,                GDK_KEY_plus,   zoom,       { .i = +1 } },

	{ MODKEY,                GDK_KEY_p,      clipboard,  { .i = 1 } },
	{ MODKEY,                GDK_KEY_y,      clipboard,  { .i = 0 } },

	{ MODKEY,                GDK_KEY_n,      find,       { .i = +1 } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_n,      find,       { .i = -1 } },

	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_p,      print,      { 0 } },

//	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_a,      togglecookiepolicy, { 0 } },
	{ 0,                     GDK_KEY_F11,    togglefullscreen, { 0 } },
//	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_o,      toggleinspector, { 0 } },

	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_c,      toggle,     { .i = CaretBrowsing } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_f,      toggle,     { .i = FrameFlattening } },
//	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_g,      toggle,     { .i = Geolocation } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_s,      toggle,     { .i = JavaScript } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_i,      toggle,     { .i = LoadImages } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_v,      toggle,     { .i = Plugins } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_t,      toggle,     { .i = StrictTLS } },
	{ MODKEY|GDK_SHIFT_MASK, GDK_KEY_m,      toggle,     { .i = Style } },
};

/* button definitions */
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



/* -------------- IGNORE ------------------------ */
static SiteSpecific certs[] = {{"://ewioajeowidfaweoijfdsf\\.org/", "ewioajeowidfaweoijfdsf.org.crt" },};
static int surfuseragent    = 0; /* I'd rather not have a user-agent... */
static int winsize[] = { 800, 600 }; /* irrelevant, using tiling window manager */
