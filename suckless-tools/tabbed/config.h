static const char font[]        = "Terminus:pixelsize=12:antialias=false:autohint=false";
static const char* selbgcolor   = "#5F819D";
static const char* selfgcolor   = "#DCDFDD";
static const char* normbgcolor  = "#373B41";
static const char* normfgcolor  = "#DCDFDD";
static const char* urgbgcolor   = "#CC6666";
static const char* urgfgcolor   = "#ffffff";
static const char before[]      = "<";
static const char after[]       = ">";
static const char titletrim[]   = "...";
static const int  tabwidth      = 80;
static const Bool foreground    = True;
static       Bool urgentswitch  = False;

/* Where to place a new tab when it is opened. When npisrelative is True,
 * then the current position is changed + newposition. If npisrelative
 * is False, then newposition is an absolute position.  */
static int  newposition   = 1;
static Bool npisrelative  = True;

#define SETPROP(p) { \
        .v = (char *[]){ "/bin/sh", "-c", \
                "prop=\"`xwininfo -children -id $1 | grep '^     0x' |" \
                "sed -e's@^ *\\(0x[0-9a-f]*\\) \"\\([^\"]*\\)\".*@\\1 \\2@' |" \
                "xargs -0 printf %b | dmenu -l 10`\" &&" \
                "xprop -id $1 -f $0 8s -set $0 \"$prop\"", \
                p, winid, NULL \
        } \
}

#define MODKEY ControlMask
static Key keys[] = {
	/* modifier             key        function     argument */
	{ MODKEY,     XK_n, focusonce,   { 0 } },
	{ MODKEY,     XK_n, spawn,       { 0 } },


     /* ------ shifts to next tab ------ */
    { MODKEY|ShiftMask,     XK_k,      rotate,      { .i = +1 } },
    { MODKEY|ShiftMask,     XK_j,      rotate,      { .i = -1 } },

    { MODKEY,               XK_Tab,    rotate,      { .i = +1 } },
    { MODKEY|ShiftMask,     XK_Tab,    rotate,      { .i = -1 } },
    { ShiftMask,            XK_Tab,    rotate,      { .i = 0 } }, // back-&-forth

    /* ------- moves a tab left or right in stack ---- */
    { MODKEY|ShiftMask,     XK_h,      movetab,     { .i = -1 } },
    { MODKEY|ShiftMask,     XK_l,      movetab,     { .i = +1 } },

	{ MODKEY,               XK_w,      killclient,  { 0 } },

    /* this opens dmenu to rifle through tabs */
	/* { MODKEY,               XK_m,  spawn,       SETPROP("_TABBED_SELECT_TAB") }, */

	{ MODKEY,               XK_1,      move,        { .i = 0 } },
	{ MODKEY,               XK_2,      move,        { .i = 1 } },
	{ MODKEY,               XK_3,      move,        { .i = 2 } },
	{ MODKEY,               XK_4,      move,        { .i = 3 } },
	{ MODKEY,               XK_5,      move,        { .i = 4 } },
	{ MODKEY,               XK_6,      move,        { .i = 5 } },
	{ MODKEY,               XK_7,      move,        { .i = 6 } },
	{ MODKEY,               XK_8,      move,        { .i = 7 } },
	{ MODKEY,               XK_9,      move,        { .i = 8 } },
	{ MODKEY,               XK_0,      move,        { .i = 9 } },
	{ MODKEY,               XK_u,      focusurgent, { 0 } },
	/* { MODKEY|ShiftMask,     XK_u,      toggle,      { .v = (void*) &urgentswitch } }, */
	{ 0,                    XK_F11,    fullscreen,  { 0 } },
};
