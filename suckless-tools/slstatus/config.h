static const int interval = 1000;
#define MAXLEN 512

static const struct arg args[] = {

    { run_command, "[ %s ]", "sh /home/mitch/bin/get-song.sh"        },
    { run_command, "[ %s ]", "sh /home/mitch/bin/battery-check.sh"   },
    { run_command, "[ %s ]", "sh /home/mitch/bin/wifi-check.sh iwn0" },
    { run_command, "[ %s ]", "sh /home/mitch/bin/vpn-check.sh"       },

	{ datetime,    "[ %s ]",    "%a %b %d - %H:%M"                          },

};
