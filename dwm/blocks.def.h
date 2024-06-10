#include <stdlib.h>

static const Block blocks[] = {
    /*Icon*/	     /*Command*/                                               /*Update Interval*/   /*Update Signal*/

    {"  ",  	     "top -bn1 -n1 | grep '%Cpu(s)' | awk '{print $2+$4+$6\"%  \"}'",      		         60,                 0},
    {"",	     "sensors | grep 'Tctl' | awk '{print substr($2, 2)}'",                      		 60,                 0}, // PC
    {"      ",      "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | sed 's/ //g'",              60,                 0}, // PC
    {"  ",	     "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader | awk '{print $1 \"°C\"}'", 	 60,                 0}, // PC
    {"      ",      "top -bn1 -n1 | grep 'MiB Mem' | awk '{printf \"%.1fGB\\n\", \$8 / 1024\"GB\"}'",	         60,                 0},
    {"    󰥔  ",	     "date '+%H:%M %-d %B %Y'",                                          	                 60,                 0},
};

static char delim[] = "\0";
static unsigned int delimLen = 0;
