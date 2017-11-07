/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nobody";

/* time to cancel lock with mouse movement in seconds */
static const int timetocancel = 3;

static const char *colorname[NUMCOLS] = {
    [INIT] =   "black",     /* after initialization */
    [INPUT] =  "#005577",   /* during input */
    [FAILED] = "#CC3333",   /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* time in seconds before the monitor shuts down */
static const int monitortime = 4;
