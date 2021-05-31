for cpu in `ls -d /sys/devices/system/cpu/cpu[0-9]*`
do
	echo performance > ${cpu}/cpufreq/scaling_governor
done
