#!/bin/bash

# === RAM ===
ram=$(free -h --si | awk '/^Mem:/ {print $3 "/" $2 " 󰾆"}')

# === CPU ===
read cpu user nice system idle iowait irq softirq steal _ < /proc/stat
prev_idle=$idle
prev_total=$((user+nice+system+idle+iowait+irq+softirq+steal))
sleep 0.5
read cpu user nice system idle iowait irq softirq steal _ < /proc/stat
idle_delta=$((idle-prev_idle))
total_delta=$((user+nice+system+idle+iowait+irq+softirq+steal - prev_total))
cpu=$(( (100*(total_delta-idle_delta))/total_delta ))
cpu="${cpu}% 󰍛"

# === Battery ===
battery=$(upower -i "$(upower -e | grep BAT)" | awk -F: '
  /state/ {st=$2}
  /percentage/ {pc=$2}
  END {
    gsub(/ /,"",st); gsub(/ /,"",pc)
    if (st=="charging") print pc " Charging"
    else print pc
  }')

# === Date ===
date=$(date +"%H:%M, %a %d %b")

# === Print final ===
# Weather is fetched from a separate script
echo "#[fg=colour213,bold]$date #[fg=yellow]| #[fg=blue]$("$HOME/.config/tmux/weather.sh") #[fg=yellow]| #[fg=green]$ram, #[fg=magenta]$cpu #[fg=yellow]| #[fg=cyan]$battery"

