#include "dwm-configh-ignore.h"
static unsigned int gappx = 10; /* gap pixel between windows */
static const unsigned int gapX = 10;
static const unsigned int gapY = 10;
static unsigned int borderpx  = 5; /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int minwsz    = 10;       /* min height for smfact */
static const char *fonts[]      = { "Terminus:pixelsize=12:antialias=false:autohint=false" };
static const char gray1[]           = "#222222";
static const char gray3[]           = "#bbbbbb";
static const char gray4[]           = "#eeeeee";
static const char bright_blue[]     = "#8DEEEE";
static const char gray_purple[]     = "#332a2a";
static const char red[]             = "#ee4444";
/* static const char yellow[]       = "#ffe863"; */
/* static const char pink[]         = "#ffbad2"; */
/* static const char cyan[]         = "#005577"; */
/* static const char gray2[]        = "#444444"; */

/* make sure to set this to the background of st */
static const char ST_BACKGROUND[] = "#373B41";

static const char *colors[][3]      = {
    /*               fg           bg           border                         */
    [SchemeNorm] = { gray3,       gray1,       ST_BACKGROUND }, // unfocused wins
    [SchemeSel]  = { bright_blue, gray_purple, bright_blue }, // the focused win
    [SchemeUrg] =  { gray4,       red,         red },
};

static const char *tags[] = { "", "", "", "", "", "", "", "", "", \
                              "", "", "", "" };

static const Rule rules[] = {
    /* class      instance    title       tags mask  iscentered   isfloating   monitor */
    { "Gimp",     NULL,       NULL,       0,         0,           1,           -1 },

    // surf-download and surf-translate
    { "st",       NULL,       "surf-download",      0,         1,           1,           -1 },
    { "st",       NULL,       "surf-translate",     0,         1,           1,           -1 },
};

static const float mfact  = 0.50; /* factor of master area size [0.05..0.95] */
static const float smfact = 0.00; /* factor of tiled clients */
static const int nmaster     = 1;    /* number of clients in master area */

#include "layouts.c"
#include "horizgrid.c"
#include "fibonacci.c"
static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[T]",      tile },    /* first entry is default */
    { "[F]",      NULL },    /* no layout function means floating behavior */
    { "[GGG]",    grid },
    { "[TTT]",    bstack},
    { "[MMM]",    centeredmaster },
    { "[HHH]",    horizgrid },
    { "[FFF]",    dwindle },
};

#define mod1 Mod1Mask
#define shift ShiftMask
#define ctrl ControlMask
#define TAGKEYS(KEY,TAG) \
{ mod1,            KEY,      view,           {.ui = 1 << TAG} }, \
{ mod1|ctrl,       KEY,      toggleview,     {.ui = 1 << TAG} }, \
{ mod1|shift,      KEY,      tag,            {.ui = 1 << TAG} }, \
{ mod1|ctrl|shift, KEY,      toggletag,      {.ui = 1 << TAG} },

static void toggle_gaps(){
    if(gappx == 0){
        gappx = gapX;
        borderpx = 5;
    } else {
        gappx = 0;
        borderpx = 4;
    }
}

static const char *term[]  = { "tabbed", "-c", "-r", "2", "st", "-w", "''", NULL };
/* static const char *term[]  = { "st", NULL }; */
static const char *net[] = { "tabbed", "-c", "surf", "-e", NULL };
static const char *ranger[] = { "st", "-e", "ranger", NULL };
static const char *vimwiki[] = { "st", "-w", "Vimwiki", "-T", "Vimwiki", "-n", "Vimwiki", "-e", "nvim", "-c VimwikiIndex", NULL };
static const char *musicplayer[] = { "st", "-w", "music", "-T", "music", "-n", "music", "-e", "ranger", "/home/mitch/music", NULL };
static const char *clipboard[] = { "clipmenu", NULL };
static const char *dedit[] = { "dedit", NULL };
static const char *volup[] = { "BSDNixVolume.sh", "-set", "+5", NULL };
static const char *voldown[] = { "BSDNixVolume.sh", "-set", "-5", NULL };
static const char *mpdnext[] = { "mpc", "-q",  "next", NULL };
static const char *mpdprev[] = { "mpc", "-q", "prev", NULL };
static const char *mpdtoggle[] = { "mpc", "-q",  "toggle", NULL };
static const char *mpdseekff[] = { "mpc", "-q", "seek", "+00:00:30", NULL };
static const char *mpdseekrw[] = { "mpc", "-q", "seek", "-00:00:30", NULL };
static const char *slock[] = { "slock", NULL };
static const char *screenshot[] = { "screenshot", NULL };
/* static const char *xdgopen[] = { "/home/mitch/workspace/dotfiles/suckless-tools/dwm/scripts-dwm/xdgopen.sh", NULL }; */

#include "movestack.c"
#define SH(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
static Key keys[] = {
	/* modifier                     key        function        argument */
    // ------------------------------------------------------------------- //
    { mod1,                     XK_p,             spawn,    {.v = dmenucmd } },
    { mod1,                     XK_Return,        spawn,    {.v = term } },
    { mod1,                     XK_w,             spawn,    {.v = net } },
    { mod1,                     XK_o,             spawn,    {.v = dedit } },
    { mod1,                     XK_c,             spawn,    {.v = clipboard } },
    { mod1,                     XK_r,             spawn,    {.v = ranger } },

    { mod1,                     XK_e,             spawn,    {.v = vimwiki } },
    { mod1,                     XK_a,             spawn,    {.v = musicplayer } },

    { mod1,                     XK_slash,         spawn,    {.v = mpdtoggle } },
    { mod1,                     XK_period,        spawn,    {.v = mpdnext } },
    { mod1,                     XK_comma,         spawn,    {.v = mpdprev } },
    { 0,                        XK_Print,         spawn,    {.v = screenshot} },
    { mod1,                     XK_semicolon,     spawn,    {.v = voldown }},
    { mod1,                     XK_apostrophe,    spawn,    {.v = volup }},

    { mod1,                     XK_bracketleft,   spawn,    {.v = mpdseekrw }},
    { mod1,                     XK_bracketright,  spawn,    {.v = mpdseekff }},

    /* { ctrl,         XK_l,       spawn,          {.v = xdgopen } }, */

    // xf86 keys must be in octal
    /* { 0,                        0x1008ff12, spawn,          {.v = volmute }}, */
    { 0,                        0x1008ff11, spawn,          {.v = voldown }},
    { 0,                        0x1008ff13, spawn,          {.v = volup }},

    { 0,                        0x1008ff17, spawn,          {.v = mpdnext } },
    { 0,                        0x1008ff16, spawn,          {.v = mpdprev } },
    { 0,                        0x1008ff14, spawn,          {.v = mpdtoggle } },

    { 0,                        0x1008ff2a, spawn,          {.v = slock }},
    { mod1,                     XK_x,       spawn,          {.v = slock }},
    // ------------------------------------------------------------------ //
    { mod1,                     XK_j,       focusstack,     {.i = +1 } },
    { mod1,                     XK_k,       focusstack,     {.i = -1 } },
    { mod1,                     XK_l,       movestack,      {.i = +1 } },
    { mod1,                     XK_h,       movestack,      {.i = -1 } },
    // ------------------------------------------------------------------- //
    { mod1|shift,           XK_h,       setmfact,       {.f = -0.05} },
    { mod1|shift,           XK_l,       setmfact,       {.f = +0.05} },
    { mod1|shift,           XK_k,       setsmfact,      {.f = +0.05} },
    { mod1|shift,           XK_j,       setsmfact,      {.f = -0.05} },
    // ------------------------------------------------------------------- //
    { mod1,                 XK_Tab,     view,           {0} },
    { mod1|shift,           XK_g,       toggle_gaps,    {0} },
    { mod1|shift,           XK_space,   togglefloating, {0} },
    // ------------------------------------------------------------------- //
    { mod1,                     XK_t,       setlayout,  {.v = &layouts[0]} }, // tiled
    { mod1,                     XK_f,       setlayout,  {.v = &layouts[1]} }, // floating
    { mod1,                     XK_g,       setlayout,  {.v = &layouts[2]} }, // grid
    { mod1,                     XK_b,       setlayout,  {.v = &layouts[3]} }, // top master
    { mod1,                     XK_m,       setlayout,  {.v = &layouts[4]} }, // middle master
    { mod1,                     XK_n,       setlayout,  {.v = &layouts[5]} }, // +1 top master, bottom children
    { mod1,                     XK_v,       setlayout,  {.v = &layouts[6]} }, // fibonacci
    { mod1,                     XK_space,   setlayout,  {0} }, // toggle between last 2 layouts
    // ------------------------------------------------------------------- //
    { mod1|shift,               XK_b,       togglebar,  {0} },
    { mod1,                     XK_q,       killclient, {0} },
    { mod1|shift|ctrl,          XK_q,       quit,       {0} },
    // ------------------------------------------------------------------- //
    /* { mod1,                     XK_0,       view,           {.ui = ~0 } }, */
    /* { mod1|shift,           XK_0,       tag,            {.ui = ~0 } }, */
    // ------------------------------------------------------------------- //
    TAGKEYS(XK_1,0) TAGKEYS(XK_2,1) TAGKEYS(XK_3,2) TAGKEYS(XK_4,3)
	TAGKEYS(XK_5,4) TAGKEYS(XK_6,5) TAGKEYS(XK_7,6) TAGKEYS(XK_8,7)
    TAGKEYS(XK_9,8) TAGKEYS(XK_0,9) TAGKEYS(XK_minus,10) TAGKEYS(XK_equal,11)
    TAGKEYS(XK_BackSpace,12)
};

/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkClientWin,         mod1,           Button1,        movemouse,      {0} },
	{ ClkClientWin,         mod1,           Button3,        resizemouse,    {0} },
	/* { ClkClientWin,         mod1,           Button2,        togglefloating, {0} }, */
    /* { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} }, */
	/* { ClkWinTitle,          0,              Button2,        zoom,           {0} }, */
	/* { ClkStatusText,        0,              Button2,        spawn,          {.v = term } }, */
	/* { ClkTagBar,            mod1,           Button1,        tag,            {0} }, */
	/* { ClkTagBar,            mod1,           Button3,        toggletag,      {0} }, */
};
