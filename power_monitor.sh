#!/bin/bash
prev_energy=$(cat /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj)
interval=0.5

bar_color='\e[0;102m' # Green background color 
default_color='\e[49m'  # Default background color
max_power=$(grep . /sys/class/powercap/intel-rapl/intel-rapl:0/constraint_0_max_power_uw )
max_power=$(echo $max_power/1000000 | bc)
prev_time=0
while true; do
	clear >$(tty)	
	width=$(tput cols)
	current_energy=$(cat /sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj)
	current_time=$(date -u +%s.%N)
	#used_energy=$(echo "scale=6; $current_energy - $prev_energy" | bc)
	power_consumption=$(echo "scale=2; ($current_energy - $prev_energy) / 1000000 / ($current_time - $prev_time)" | bc)
	prev_energy=$current_energy
	prev_time=$current_time
	#echo $current_energy
	#echo $max_power
	num_chars=$(echo "scale=2; ($power_consumption)/$max_power" | bc )

	num_chars=$(echo "scale=2; $num_chars*$width" | bc )

	current_energy_in_W=$(echo "scale=2; ($power_consumption)" | bc )


	printf "${bar_color}%-${num_chars-1}s>${default_color}\n"
	printf " Current Power: $current_energy_in_W W \r" ''
	sleep $interval
done
