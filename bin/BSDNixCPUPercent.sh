#!/bin/bash


# TODO: convert this to POSIX to get rid of bash dependency.
# --------------------------------------------------------------------------  #

# 1. get total average CPU usage for the past minute
# avg_cpu_use=$(uptime)

# 2. split response
# IFS=',' read -ra avg_cpu_use_arr <<< "$avg_cpu_use"



avg_cpu_use=$(uptime | awk -F'load averages:' '{ print $2 }')

echo ""

echo $avg_cpu_use

echo ""

# 3. find cpu usage
# avg_cpu_use=""
# for i in "${avg_cpu_use_arr[@]}"; do :
#     if [[ $i == *"load average"* ]]; then
#         avg_cpu_use=$i
#         break       
#     fi
# done

# 4. Remove "  load average: "
# avg_cpu_use=$(echo ${avg_cpu_use:16})

# 5. Convert to percentage
# avg_cpu_use=$(echo $avg_cpu_use \* 100 | bc | sed 's/...$//')


echo $avg_cpu_use%
