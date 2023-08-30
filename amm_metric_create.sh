#!/bin/bash
output_file="/t3local/infvhp/monitoring/prom-proxy-agent/scripts/amm_metrics.txt"
LD_LIBRARY_PATH="/t3infinys/infvhp/AMM/MZ/lib"
MZ_HOME="/t3infinys/infvhp/AMM/MZ"
MZ_PASSWORD="fF6B_J2A6jceSa"
MZ_USERNAME="mzadmin"
#COMMAND="/t3infinys/infvhp/AMM/MZ/bin/mzsh"
echo "# HELP amm_login_availability statics UP = 1, DOWN = 0"
echo "# TYPE amm_login_availability gauge"

# Run the command and store the output
output=()
#output=$( ${MZ_HOME}/bin/mzsh status)
output=$( ${MZ_HOME}/bin/mzsh ${MZ_USERNAME}/${MZ_PASSWORD} status)
echo $(date) >> $output_file
echo $(printenv|grep -i MZ) >> $output_file
echo $output >> $output_file
# Process the output to create metric values
while read -r line; do
  service_name=$(echo "$line" | awk '{print $1}')
  status=$(echo "$line" | awk '{print $3}')

  if [ "$status" = "running" ]; then
    metric_value=1.0
  else
    metric_value=0.0
  fi

#echo "amm_login_availability{service_name=\"$service_name\"} $metric_value"
  echo $(printf "amm_login_availability{service_name=\"%s\"} %s" $service_name $metric_value)
  echo $(printf "amm_login_availability{service_name=\"%s\"} %s" $service_name $metric_value) >> $output_file

done <<< "$output"
