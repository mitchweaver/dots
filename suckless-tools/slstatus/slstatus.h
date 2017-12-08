/* See LICENSE file for copyright and license details. */

/* battery */
const char *battery_perc(const char *);
const char *battery_power(const char *);
const char *battery_state(const char *);

/* cpu */
const char *cpu_freq(void);
const char *cpu_perc(void);
const char *cpu_iowait(void);

/* datetime */
const char *datetime(const char *);

/* disk */
const char *disk_free(const char *);
const char *disk_perc(const char *);
const char *disk_total(const char *);
const char *disk_used(const char *);

/* entropy */
const char *entropy(void);

/* hostname */
const char *hostname(void);

/* ip */
const char *ipv4(const char *);
const char *ipv6(const char *);

/* kernel_release */
const char *kernel_release(void);

/* keyboard_indicators */
const char *keyboard_indicators(void);

/* load_avg */
const char *load_avg(const char *);

/* num_files */
const char *num_files(const char *);

/* ram */
const char *ram_free(void);
const char *ram_perc(void);
const char *ram_total(void);
const char *ram_used(void);

/* run_command */
const char *run_command(const char *);

/* swap */
const char *swap_free(void);
const char *swap_perc(void);
const char *swap_total(void);
const char *swap_used(void);

/* temperature */
const char *temp(const char *);

/* uptime */
const char *uptime(void);

/* user */
const char *gid(void);
const char *username(void);
const char *uid(void);

/* volume */
const char *vol_perc(const char *);

/* wifi */
const char *wifi_perc(const char *);
const char *wifi_essid(const char *);
