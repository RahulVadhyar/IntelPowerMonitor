#!/bin/bash
prev_energy=$(cat /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj)
interval=1

prev_time=0
while true; do
	current_energy=$(cat /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj)
	current_time=$(date -u +%s.%N)
	#used_energy=$(echo "scale=6; $current_energy - $prev_energy" | bc)
	power_consumption=$(echo "scale=6; ($current_energy - $prev_energy) / 1000000 / ($current_time - $prev_time)" | bc)
	prev_energy=$current_energy
	prev_time=$current_time
	echo "The power consumption is $power_consumption Watts"
	sleep $interval
done
