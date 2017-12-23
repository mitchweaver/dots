// -------- might change these, rarely ---------------------------
/* Highest priority value will be used.
 * Default parameters are priority 0
 * Per-uri parameters are priority 1
 * Command parameters are priority 2 */
static Parameter defconfig[ParameterLast] = {
	/* parameter                    Arg value       priority */
	[AccessMicrophone]    =       { { .i = 0 },     },
	[AccessWebcam]        =       { { .i = 0 },     },
    [FontSize]            =       { { .i = 12 },    },
	[ZoomLevel]           =       { { .f = 1.2 },   },
	[DNSPrefetch]         =       { { .i = 0 },     },
	[Plugins]             =       { { .i = 1 },     },
	[JavaScript]          =       { { .i = 1 },     },
            // -------------------------- //
	[AcceleratedCanvas]   =       { { .i = 1 },     },
	[Certificate]         =       { { .i = 0 },     },
	[CaretBrowsing]       =       { { .i = 0 },     },
	[CookiePolicies]      =       { { .v = "@Aa" }, },
	[DefaultCharset]      =       { { .v = "UTF-8" }, },
	[DiskCache]           =       { { .i = 1 },     },
    [FileURLsCrossAccess] =       { { .i = 1 },     },
	[FrameFlattening]     =       { { .i = 0 },     }, // what does this do?
	[Geolocation]         =       { { .i = 0 },     },
	[HideBackground]      =       { { .i = 0 },     },
	[Inspector]           =       { { .i = 0 },     },
	[Java]                =       { { .i = 0 },     }, // LOLSECURITY?
	[KioskMode]           =       { { .i = 0 },     },
	[LoadImages]          =       { { .i = 1 },     },
	[MediaManualPlay]     =       { { .i = 1 },     },
	[PreferredLanguages]  =       { { .v = (char *[]){ NULL } }, },
	[RunInFullscreen]     =       { { .i = 0 },     },
	[ScrollBars]          =       { { .i = 0 },     }, // FUCK SCROLLBARS
	[ShowIndicators]      =       { { .i = 0 },     }, // letters at the start of tabs
	[SiteQuirks]          =       { { .i = 1 },     },
	[SmoothScrolling]     =       { { .i = 1 },     },
	[SpellChecking]       =       { { .i = 0 },     }, // Who needs this, really?
	[SpellLanguages]      =       { { .v = ((char *[]){ "en_US", NULL }) }, },
	[StrictTLS]           =       { { .i = 1 },     },
	[Style]               =       { { .i = 1 },     },
}; /* -------------------------------------------------------------------------- */




// I never touch these and got tired of seeing them in my config.h
/* -------------- IGNORE ------------------------ */
static SiteSpecific certs[] = {{"://ewioajeowidfaweoijfdsf\\.org/", "ewioajeowidfaweoijfdsf.org.crt" },};
static int surfuseragent    = 0;
static int winsize[] = { 1280, 800 };
static char *fulluseragent  = "";
static char *scriptfile     = "~/.surf/script.js";
static char *styledir       = "~/.surf/styles/";
static char *certdir        = "~/.surf/certificates/";
static char *cachedir       = "~/.surf/cache/";
static char *cookiefile     = "~/.surf/cookies.txt";
static WebKitFindOptions findopts = WEBKIT_FIND_OPTIONS_CASE_INSENSITIVE | WEBKIT_FIND_OPTIONS_WRAP_AROUND;
/* SETPROP(readprop, setprop, prompt)*/
#define SETPROP(r, s, p) { \
        .v = (const char *[]){ "/bin/sh", "-c", \
             "prop=\"$(printf '%b' \"$(xprop -id $1 $2 " \
             "| sed \"s/^$2(STRING) = //;s/^\\\"\\(.*\\)\\\"$/\\1/\")\" " \
             "| dmenu -p \"$4\" -w $1)\" && xprop -id $1 -f $3 8s -set $3 \"$prop\"", \
             "surf-setprop", winid, r, s, p, NULL \
        } \
}
