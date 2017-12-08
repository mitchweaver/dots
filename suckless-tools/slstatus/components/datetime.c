/* See LICENSE file for copyright and license details. */
#include <time.h>

#include "../util.h"

const char *
datetime(const char *fmt)
{
	time_t t;

	t = time(NULL);
	if (strftime(buf, sizeof(buf), fmt, localtime(&t)) == 0)
		return NULL;

	return buf;
}
