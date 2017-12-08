/* See LICENSE file for copyright and license details. */
#include <err.h>
#include <fcntl.h>
#include <sys/soundcard.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "../util.h"

const char *
vol_perc(const char *card)
{
	unsigned int i;
	int v, afd, devmask;
	char *vnames[] = SOUND_DEVICE_NAMES;

	afd = open(card, O_RDONLY | O_NONBLOCK);
	if (afd == -1) {
		warn("Cannot open %s", card);
		return NULL;
	}

	if (ioctl(afd, SOUND_MIXER_READ_DEVMASK, &devmask) == -1) {
		warn("Cannot get volume for %s", card);
		close(afd);
		return NULL;
	}
	for (i = 0; i < LEN(vnames); i++) {
		if (devmask & (1 << i) && !strcmp("vol", vnames[i])) {
			if (ioctl(afd, MIXER_READ(i), &v) == -1) {
				warn("vol_perc: ioctl");
				close(afd);
				return NULL;
			}
		}
	}

	close(afd);

	return bprintf("%d", v & 0xff);
}
