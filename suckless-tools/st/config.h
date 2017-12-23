char font[] = "Terminus:pixelsize=14:antialias=false:autohint=false";
/* char font[] = "DejaVuSans Mono:pixelsize=12:antialias=true:autohint=true"; */

/* ----------------- Themes ------------------------------------------------- */
#include "ashes-dark-theme.h"
/* #include "ashes-light-theme.h" */
/* #include "mocha-dark-theme.h" */
/* #include "mocha-light-theme.h" */
/* #include "navy-and-ivory-theme.h" */
/* #include "visibone-theme.h" */
/* #include "tomorrow-dark-theme.h" */
/* #include "ocean-dark-theme.h" */
/* #include "hund-theme.h" */
/* -------------------------------------------------------------------------- */

unsigned int alpha = 0xdd; // bit darker opacity
/* unsigned int alpha = 0xcc; // opacity */

unsigned int cols = 60;
unsigned int rows = 20;
int borderpx = 6; /* Internal border */
static char shell[] = "/bin/ksh";
/* ---------------------------------------------------------------------- */

/* Kerning / character bounding-box multipliers */
float cwscale = 1.0;
float chscale = 1.0;
static unsigned int tabspaces = 4;

/* frames per second st should at maximum draw to the screen */
unsigned int xfps = 60;
unsigned int actionfps = 30;

/* #include "solarized-light.h" */
#include "solarized-dark.h"
unsigned int defaultrcs = 257;

/* Default colour and shape of the mouse cursor */
unsigned int mousefg = 7;
unsigned int mousebg = 0;

#define CONTROL ControlMask
#define SHIFT ShiftMask
MouseKey mkeys[] = {
	/* button               mask            function        argument */
	{ Button4,              XK_NO_MOD,      kscrollup,      {.i =  1} },
	{ Button5,              XK_NO_MOD,      kscrolldown,    {.i =  1} },
    { Button4,              CONTROL,        zoom,           {.f =  +1} },
	{ Button5,              CONTROL,        zoom,           {.f =  -1} },
};

// i don't use bash anymore, but this was sort of neat:
/* void history(){ system("cat ~/.bash_history | dmenu -l 12 | /bin/bash"); } */

Shortcut shortcuts[] = {
	/* mask                 keysym          function        argument */
	{ CONTROL,              XK_equal,       zoom,           {.f = +2} },
	{ CONTROL,              XK_minus,       zoom,           {.f = -2} },
	{ CONTROL,              XK_BackSpace,   zoomreset,      {.f =  0} },
    { SHIFT,                XK_Insert,      clippaste,      {.i =  0} },
	{ CONTROL,              XK_Page_Up,     kscrollup,      {.i = 2} },
	{ CONTROL,              XK_Page_Down,   kscrolldown,    {.i = 2} },

    /* -------------- Custom Funcs ---------------------------------------------- */
    /* { CONTROL,              XK_h,           history,        {.i = 0} }, */
    // note copyurl has been edited to also open in xdg-open
	{ CONTROL,              XK_l,           copyurl,        {.i =  0} },
    /* -------------------------------------------------------------------------- */

    // not sure what this one does:
	/* { CONTROL,              XK_I,           iso14755,       {.i =  0} }, */
    /* { XK_ANY_MOD,           XK_Break,       sendbreak,      {.i =  0} }, */
	/* { CONTROL,              XK_Y,           selpaste,       {.i =  0} }, */
    /* { XK_ANY_MOD,           XK_F6,          swapcolors,     {.i =  0} }, */
};

#include "configh-do-not-touch.h"
