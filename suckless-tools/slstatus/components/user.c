/* See LICENSE file for copyright and license details. */
#include <err.h>
#include <pwd.h>
#include <sys/types.h>
#include <unistd.h>

#include "../util.h"

const char *
gid(void)
{
	return bprintf("%d", getgid());
}

const char *
username(void)
{
	struct passwd *pw = getpwuid(geteuid());

	if (pw == NULL) {
		warn("Failed to get username");
		return NULL;
	}

	return bprintf("%s", pw->pw_name);
}

const char *
uid(void)
{
	return bprintf("%d", geteuid());
}
