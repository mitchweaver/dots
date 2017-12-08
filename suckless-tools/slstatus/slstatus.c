#include <err.h>
#include <errno.h>
#include <locale.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
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
static unsigned short int done;
static Display *dpy;

#include "config.h"

static void
terminate(const int signo) {
	(void)signo;
	done = 1;
}

static void
difftimespec(struct timespec *res, struct timespec *a, struct timespec *b) {
	res->tv_sec = a->tv_sec - b->tv_sec - (a->tv_nsec < b->tv_nsec);
	res->tv_nsec = a->tv_nsec - b->tv_nsec +
	               (a->tv_nsec < b->tv_nsec) * 1000000000;
}

static void
usage(void) {
	fprintf(stderr, "usage: %s [-s]\n", argv0);
	exit(1);
}

int
main(int argc, char *argv[]) {
	struct sigaction act;
	struct timespec start, current, diff, intspec, wait;
	size_t i, len;
	int sflag = 0;
	char status[MAXLEN];

	ARGBEGIN {
		case 's':
			sflag = 1;
			break;
		default:
			usage();
	} ARGEND

	if (argc) {
		usage();
	}

	setlocale(LC_ALL, "");

	memset(&act, 0, sizeof(act));
	act.sa_handler = terminate;
	sigaction(SIGINT,  &act, NULL);
	sigaction(SIGTERM, &act, NULL);

	if (!sflag && !(dpy = XOpenDisplay(NULL))) {
		fprintf(stderr, "slstatus: cannot open display");
		return 1;
	}

	while (!done) {
		clock_gettime(CLOCK_MONOTONIC, &start);

		status[0] = '\0';
		for (i = len = 0; i < LEN(args); i++) {
			len += snprintf(status + len, sizeof(status) - len,
			                args[i].fmt, args[i].func(args[i].args));

			if (len >= sizeof(status)) {
				status[sizeof(status) - 1] = '\0';
			}
		}

		if (sflag) {
			printf("%s\n", status);
		} else {
			XStoreName(dpy, DefaultRootWindow(dpy), status);
			XSync(dpy, False);
		}

		if (!done) {
			clock_gettime(CLOCK_MONOTONIC, &current);
			difftimespec(&diff, &current, &start);

			intspec.tv_sec = interval / 1000;
			intspec.tv_nsec = (interval % 1000) * 1000000;
			difftimespec(&wait, &intspec, &diff);

			if (wait.tv_sec >= 0) {
				nanosleep(&wait, NULL);
			}
		}
	}

	if (!sflag) {
		XStoreName(dpy, DefaultRootWindow(dpy), NULL);
		XCloseDisplay(dpy);
	}

	return 0;
}
