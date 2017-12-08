/* See LICENSE file for copyright and license details. */
#include <stdio.h>
#include <string.h>

#include "../util.h"

const char *
cpu_freq(void)
{
	int freq;

	return (pscanf("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq",
	               "%i", &freq) == 1) ?
	       bprintf("%d", (freq + 500) / 1000) : NULL;
}

const char *
cpu_perc(void)
{
	int perc;
	static long double a[7];
	static int valid;
	long double b[7];

	memcpy(b, a, sizeof(b));
	if (pscanf("/proc/stat", "%*s %Lf %Lf %Lf %Lf %Lf %Lf %Lf", &a[0], &a[1], &a[2],
	           &a[3], &a[4], &a[5], &a[6]) != 7) {
		return NULL;
	}
	if (!valid) {
		valid = 1;
		return NULL;
	}

	perc = 100 * ((b[0]+b[1]+b[2]+b[5]+b[6]) - (a[0]+a[1]+a[2]+a[5]+a[6])) /
	       ((b[0]+b[1]+b[2]+b[3]+b[4]+b[5]+b[6]) - (a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]));

	return bprintf("%d", perc);
}

const char *
cpu_iowait(void)
{
	int perc;
	static int valid;
	static long double a[7];
	long double b[7];

	memcpy(b, a, sizeof(b));
	if (pscanf("/proc/stat", "%*s %Lf %Lf %Lf %Lf %Lf %Lf %Lf", &a[0], &a[1], &a[2],
	           &a[3], &a[4], &a[5], &a[6]) != 7) {
		return NULL;
	}
	if (!valid) {
		valid = 1;
		return NULL;
	}

	perc = 100 * ((b[4]) - (a[4])) /
	       ((b[0]+b[1]+b[2]+b[3]+b[4]+b[5]+b[6]) - (a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]));

	return bprintf("%d", perc);
}
