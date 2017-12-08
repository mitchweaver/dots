/* See LICENSE file for copyright and license details. */
#include <dirent.h>
#include <err.h>
#include <stdio.h>
#include <string.h>

#include "../util.h"

const char *
num_files(const char *dir)
{
	struct dirent *dp;
	DIR *fd;
	int num = 0;

	if ((fd = opendir(dir)) == NULL) {
		warn("Failed to get number of files in directory %s", dir);
		return NULL;
	}

	while ((dp = readdir(fd)) != NULL) {
		if (!strcmp(dp->d_name, ".") || !strcmp(dp->d_name, ".."))
			continue; /* skip self and parent */
		num++;
	}

	closedir(fd);

	return bprintf("%d", num);
}
