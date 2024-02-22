#!/bin/bash

prev_energy=$(cat /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj)
interval=0.5

bar_color='\e[0;102m' # Green background color 
default_color='\e[49m'  # Default background color
prev_time=0
max_power=0
while true; do
    current_energy=$(cat /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj)
    if [ $max_power -eq 0 ]; then
        max_power=$(cat /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj)
		max_power=$(echo "scale=2; $max_power / 1000000000" | bc)
    else
        if [ $((current_energy - prev_energy)) -gt $max_power ]; then
            max_power=$((current_energy - prev_energy))
        fi
    fi
    # Clear the screen
    clear
    width=$(tput cols)
	echo "cols: $width"
    current_time=$(date -u +%s.%N)
    power_consumption=$(echo "scale=2; ($current_energy - $prev_energy) / 1000000 / ($current_time - $prev_time)" | bc)
    prev_energy=$current_energy
    prev_time=$current_time
	echo "Max power: $max_power"
    num_chars=$(echo "scale=2; ($power_consumption) / $max_power * $width" | bc)

    current_energy_in_W=$(echo "scale=2; ($power_consumption)" | bc)

    printf "${bar_color}%-${num_chars}s>${default_color}\n" ''
    printf " Current Power: $current_energy_in_W W \r"
    sleep $interval
done
