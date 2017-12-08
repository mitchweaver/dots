/* See LICENSE file for copyright and license details. */
extern char buf[1024];

#define LEN(x) (sizeof (x) / sizeof *(x))

const char *bprintf(const char *fmt, ...);
int pscanf(const char *path, const char *fmt, ...);
