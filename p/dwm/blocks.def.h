#include <stdlib.h>

static const Block blocks[] = {
   /* icon, command, interval, signal */
   {"  ", "top -bn1 | grep '%Cpu(s)' | awk '{printf \"%02d%%\", int($2+$4+$6+0.5)}'", 60, 0},
   {"  ", "sensors | grep 'Tctl' | awk '{temp = int(substr($2, 2) + 0.5); printf \"%02d°C\", temp}'", 60, 0}, // pc
   {"  ", "sensors | grep 'Package id 0' | awk '{print int(substr($4, 2) + 0.5) \"°C\"}'", 60, 0}, // laptop
   {"      ", "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | awk '{printf \"%02d%%\", $1}'", 60, 0}, // pc
   {"  ", "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader | awk '{print sprintf(\"%02.0f°C\", $1)}'", 60, 0}, // pc
   {"      ", "top -bn1 | grep 'MiB Mem' | awk '{used=$8; total=$4; printf \"%02d%%\", int((used/total)*100 + 0.5)}'", 60, 0},
   {"      ", "printf \"%02d%%\" $(cat /sys/class/power_supply/BAT0/capacity)", 60, 0}, // laptop
   {"    󰥔  ", "date '+%H:%M %-d %B %Y'", 60, 0},
};

static char delim[] = "";
static unsigned int delimLen = 0;
