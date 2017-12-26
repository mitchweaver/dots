static const int interval = 1000;
#define MAXLEN 512
 /* ∙ */
static const struct arg args[] = {

    { run_command, "%s", "sh /home/mitch/bin/get-song.sh"              },
    { run_command, " %s ∙", "sh /home/mitch/bin/battery-check.sh"     },
    // if the device doesn't exist [ if disabled, or really doesn't exist ],
    // this script will spit out errors. Silence that to /dev/null.
    { run_command, " %s ∙", "sh /home/mitch/bin/wifi-check.sh iwn0 2>/dev/null"   },
    { run_command, " %s ∙", "sh /home/mitch/bin/vpn-check.sh"         },

    /* { run_command, "[ %s ]", "sh /home/mitch/bin/BSDNixCPUPercent.sh"  }, */
    { run_command, " %s ∙", "sh /home/mitch/bin/BSDNixCPUTemp.sh"     },

    { run_command, " %s ∙", "sh /home/mitch/bin/BSDNixVolume.sh -get" },

	{ datetime,    " %s ",    "%a %b %d - %H:%M"                     },

};
