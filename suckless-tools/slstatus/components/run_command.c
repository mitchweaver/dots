#include <stdio.h>
#include <string.h>
#include "../util.h"

const char * run_command(const char *cmd) {
	char *p;
	FILE *fp;

	fp = popen(cmd, "r");
	p = fgets(buf, sizeof(buf) - 1, fp);
	pclose(fp);
	if (!p) return NULL;
	if ((p = strrchr(buf, '\n')) != NULL) p[0] = '\0';

	return buf[0] ? buf : NULL;
}
