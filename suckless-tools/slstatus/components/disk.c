/* See LICENSE file for copyright and license details. */
#include <err.h>
#include <stdio.h>
#include <sys/statvfs.h>

#include "../util.h"

const char *
disk_free(const char *mnt)
{
	struct statvfs fs;

	if (statvfs(mnt, &fs) < 0) {
		warn("Failed to get filesystem info");
		return NULL;
	}

	return bprintf("%f", (float)fs.f_bsize * (float)fs.f_bfree / 1024 / 1024 / 1024);
}

const char *
disk_perc(const char *mnt)
{
	int perc;
	struct statvfs fs;

	if (statvfs(mnt, &fs) < 0) {
		warn("Failed to get filesystem info");
		return NULL;
	}

	perc = 100 * (1.0f - ((float)fs.f_bfree / (float)fs.f_blocks));

	return bprintf("%d", perc);
}

const char *
disk_total(const char *mnt)
{
	struct statvfs fs;

	if (statvfs(mnt, &fs) < 0) {
		warn("Failed to get filesystem info");
		return NULL;
	}

	return bprintf("%f", (float)fs.f_bsize * (float)fs.f_blocks / 1024 / 1024 / 1024);
}

const char *
disk_used(const char *mnt)
{
	struct statvfs fs;

	if (statvfs(mnt, &fs) < 0) {
		warn("Failed to get filesystem info");
		return NULL;
	}

	return bprintf("%f", (float)fs.f_bsize * ((float)fs.f_blocks - (float)fs.f_bfree) / 1024 / 1024 / 1024);
}
