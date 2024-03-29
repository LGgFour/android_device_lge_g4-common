#! /vendor/bin/sh

# move cpu-hungry kswapd and mmcqd/0 tasks to background cpuset
echo $(pgrep kswapd) > /dev/cpuset/background/tasks
echo $(pgrep mmcqd/0 | head -n 1) > /dev/cpuset/background/tasks
echo $(pgrep msm_watchdog) > /dev/cpuset/background/tasks
echo $(pgrep irqbalance) > /dev/cpuset/background/tasks
echo $(pgrep rild | head -n 1) > /dev/cpuset/background/tasks
echo $(pgrep rild | head -n 2 | sed /$(head -n1)/d) > /dev/cpuset/background/tasks
echo $(pgrep qmuxd) > /dev/cpuset/background/tasks
echo $(pgrep netmgrd) > /dev/cpuset/background/tasks
echo $(pgrep logd) > /dev/cpuset/background/tasks
echo $(pgrep wcnss_service) > /dev/cpuset/background/tasks

# move UI-related threads to top-app cpuset
echo $(pgrep composer) > /dev/cpuset/top-app/tasks
echo $(pgrep mdss_dsi_event) > /dev/cpuset/top-app/tasks
echo $(pgrep kgsl_worker_thr) > /dev/cpuset/top-app/tasks

# move watchdog thread to foregrond cpuset
echo $(pgrep msm_watchdog) > /dev/cpuset/foreground/tasks

