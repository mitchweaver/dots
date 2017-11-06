/* appearance */
static const unsigned int borderpx  = 0;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const char *fonts[]          = { "monospace:size=10" };
static const char dmenufont[]       = "monospace:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }; /* workspace names */

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[T]",      tile },    /* first entry is default */
	{ "[F]",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

#define mod1 Mod4Mask //super
#define mod2 Mod1Mask //alt
#define TAGKEYS(KEY,TAG) \
	{ mod1,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ mod1|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ mod1|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ mod1|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },


static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *netcmd[] = { "surf", "https://duckduckgo.com/html", NULL };
static const char *deditcmd[] = { "/home/mitch/bin/dedit", NULL };
static const char *clipboardcmd[] = { "clipmenu", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ mod1,                     XK_p,       spawn,          {.v = dmenucmd } },
	{ mod1,                     XK_Return,  spawn,          {.v = termcmd } },

    // ------------------------------------------------------------------- //
    { mod1,                     XK_w,       spawn,          {.v = netcmd } },
    { mod1,                     XK_o,       spawn,          {.v = deditcmd } },
    { mod1,                     XK_c,       spawn,          {.v = clipboardcmd } },
    // ------------------------------------------------------------------- //

	{ mod1,                     XK_b,       togglebar,      {0} },
	{ mod1,                     XK_j,       focusstack,     {.i = +1 } },
	{ mod1,                     XK_k,       focusstack,     {.i = -1 } },
	{ mod1,                     XK_i,       incnmaster,     {.i = +1 } },
	{ mod1,                     XK_d,       incnmaster,     {.i = -1 } },
	{ mod1,                     XK_h,       setmfact,       {.f = -0.05} },
	{ mod1,                     XK_l,       setmfact,       {.f = +0.05} },
	{ mod1,                     XK_Return,  zoom,           {0} },
	{ mod1,                     XK_Tab,     view,           {0} },
	{ mod2,                     XK_4,       killclient,     {0} },
	{ mod1,                     XK_t,       setlayout,      {.v = &layouts[0]} },
	{ mod1,                     XK_f,       setlayout,      {.v = &layouts[1]} },
	{ mod1,                     XK_m,       setlayout,      {.v = &layouts[2]} },
	{ mod1,                     XK_space,   setlayout,      {0} },
	{ mod1|ShiftMask,           XK_space,   togglefloating, {0} },
	{ mod1,                     XK_0,       view,           {.ui = ~0 } },
	{ mod1|ShiftMask,           XK_0,       tag,            {.ui = ~0 } },
	{ mod1,                     XK_comma,   focusmon,       {.i = -1 } },
	{ mod1,                     XK_period,  focusmon,       {.i = +1 } },
	{ mod1|ShiftMask,           XK_comma,   tagmon,         {.i = -1 } },
	{ mod1|ShiftMask,           XK_period,  tagmon,         {.i = +1 } },
	{ mod1|ShiftMask,           XK_q,      quit,            {0} },
	TAGKEYS(XK_1,0)
	TAGKEYS(XK_2,1)
	TAGKEYS(XK_3,2)
	TAGKEYS(XK_4,3)
	TAGKEYS(XK_5,4)
	TAGKEYS(XK_6,5)
	TAGKEYS(XK_7,6)
	TAGKEYS(XK_8,7)
	TAGKEYS(XK_9,8)
};

/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         mod1,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         mod1,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         mod1,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            mod1,         Button1,        tag,            {0} },
	{ ClkTagBar,            mod1,         Button3,        toggletag,      {0} },
};

// ---------------------------------------------------------------------------- //
/* SYSTEM STUFF - DO NOT CHANGE */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
static const int resizehints = 0; 
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
