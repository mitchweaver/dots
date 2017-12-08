/* See LICENSE file for copyright and license details. */
#include <sys/sysinfo.h>

#include "../util.h"

const char *
uptime(void)
{
	struct sysinfo info;
	int h = 0;
	int m = 0;

	sysinfo(&info);
	h = info.uptime / 3600;
	m = (info.uptime - h * 3600 ) / 60;

	return bprintf("%dh %dm", h, m);
}
