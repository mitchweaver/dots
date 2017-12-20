#include <err.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include "util.h"

const char * bprintf(const char *fmt, ...) {
	va_list ap;
	size_t len;

	va_start(ap, fmt);
	len = vsnprintf(buf, sizeof(buf) - 1, fmt, ap);
	va_end(ap);

	if (len >= sizeof(buf))
		buf[sizeof(buf)-1] = '\0';

	return buf;
}

int pscanf(const char *path, const char *fmt, ...) {
	FILE *fp;
	va_list ap;
	int n;

	if (!(fp = fopen(path, "r"))) {
		warn("fopen %s: %s\n", path, strerror(errno));
		return -1;
	}
	va_start(ap, fmt);
	n = vfscanf(fp, fmt, ap);
	va_end(ap);
	fclose(fp);

	return (n == EOF) ? -1 : n;
}
