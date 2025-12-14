#!/bin/bash

cpu_usage=$(grep -o '^[^ ]*' /proc/loadavg)
mem_used=$(free -h --si | awk '/Mem:/ {print $3}')
mem_total=$(free -h --si | awk '/Mem:/ {print $2}')
temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf "%.1f°C", $1/1000}')
fan="Unknown"

# Check for fan info (some systems don't expose fans)
if command -v sensors >/dev/null; then
    fan_check=$(sensors 2>/dev/null | grep -i 'fan' | awk '{print $2}' | head -1)
    [[ -n "$fan_check" ]] && fan="${fan_check}RPM" || fan="Off"
fi

text=$(printf "%s%%" "$(awk "BEGIN {print int($cpu_usage*100)}")")

tooltip=$(printf "CPU Load: %s\nRAM: %s / %s\nTemp: %s\nFan: %s" \
    "$cpu_usage" "$mem_used" "$mem_total" "$temp" "$fan")

cat <<EOF
{
  "text": "$text",
  "usage": "$text",
  "tooltip": "$tooltip"
}
EOF
