input_file="listed_iperf3_servers.csv"
output_file="ping_stats.txt"

# delete stats file if it already exists
if [ -f $output_file ]; then
  rm $output_file
fi

while read -r line; do
  # parse ip address from each line
  ip_host=$(echo $line | awk -F',' '{print $1}')
  # run ping on each ip/host server, output ip address/host and ping stats to file,
  echo $ip_host >> $output_file
  # strip standard deviation info from output
  stats=$(ping -c 5 -i 0.005 $ip_host | tail -n1 | awk '{sub(/\/stddev/, ""); print}')
  echo $stats | awk '{print substr($0, 1, length($0)-9)}' >> $output_file
done < $input_file
