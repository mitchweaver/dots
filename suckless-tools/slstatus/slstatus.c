#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <X11/Xlib.h>

#include "arg.h"
#include "slstatus.h"
#include "util.h"

struct arg {
	const char *(*func)();
	const char *fmt;
	const char *args;
};

char *argv0;
char buf[1024];
static Display *dpy;

#include "config.h"

static void difftimespec(struct timespec *res, struct timespec *a, struct timespec *b) {
	res->tv_sec = a->tv_sec - b->tv_sec - (a->tv_nsec < b->tv_nsec);
	res->tv_nsec = a->tv_nsec - b->tv_nsec +
	               (a->tv_nsec < b->tv_nsec) * 1000000000;
}

int main(int argc, char *argv[]) {
	struct timespec start, current, diff, intspec, wait;
	size_t i, len;
	char status[MAXLEN];

    // segfaults without this, not sure why.
	if (!(dpy = XOpenDisplay(NULL))) {
		fprintf(stderr, "slstatus: cannot open display");
		return 1;
	}

	while (1) {
		clock_gettime(CLOCK_MONOTONIC, &start);

		status[0] = '\0';
		for (i = len = 0; i < LEN(args); i++) {
			len += snprintf(status + len, sizeof(status) - len,
                        args[i].fmt, args[i].func(args[i].args));


            // safety check if you want, it will segfault
            // if the size is too long otherwise.
			/* if (len >= sizeof(status)) { */
			/* 	status[sizeof(status) - 1] = '\0'; */
			/* } */
		}

        XStoreName(dpy, DefaultRootWindow(dpy), status);
        XSync(dpy, False);

        clock_gettime(CLOCK_MONOTONIC, &current);
        difftimespec(&diff, &current, &start);

        intspec.tv_sec = interval / 1000;
        intspec.tv_nsec = (interval % 1000) * 1000000;
        difftimespec(&wait, &intspec, &diff);

        if (wait.tv_sec >= 0) nanosleep(&wait, NULL);
	}

	return 0;
}
