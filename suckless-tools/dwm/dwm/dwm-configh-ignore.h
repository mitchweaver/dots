// I rarely change these and got sick of seeing them in my config.h

static const unsigned int snap      = 20;       /* snap pixel */
static const unsigned int minwsz    = 10;       /* min height for smfact */
static const float mfact  = 0.50; /* factor of master area size [0.05..0.95] */
static const float smfact = 0.00; /* factor of tiled clients */
static const int nmaster     = 1;    /* number of clients in master area */

static const int resizehints = 0;
static char dmenumon[2] = "0";
static const char *dmenucmd[] = { "dmenu_run", NULL};
/* static const char dmenufont[]    = "Terminus:pixelsize=12:antialias=false:autohint=false"; */
/* static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", gray1, "-nf", gray3, "-sb", cyan, "-sf", gray4, NULL }; */

static const int showbar            = 1;        /* 0 means no bar */
