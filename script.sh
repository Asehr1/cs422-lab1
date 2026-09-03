input_file="listed_iperf3_servers.csv"
output_file="ping_stats.txt"

# delete stats file if it already exists
if [ -f $output_file ]; then
  rm $output_file
fi

echo "ip_host,min_rtt_ms,avg_rtt_ms,max_rtt_ms" >> $output_file

ping_stats() {
  # runs ping and extracts "min/avg/max" from the summary line (works for
  # both Linux "rtt min/avg/max/mdev" and macOS "round-trip min/avg/max/stddev")
  ping -c 5 -i 0.005 "$1" 2>/dev/null | grep -oE '[0-9.]+/[0-9.]+/[0-9.]+' | head -n1
}

write_row() {
  # pings $1, writes a CSV row labeled $2: label,min,avg,max (blank fields if unresponsive)
  local host="$1"
  local label="$2"
  local stats
  stats=$(ping_stats "$host")
  if [ -n "$stats" ]; then
    echo "$label,$(echo "$stats" | cut -d/ -f1),$(echo "$stats" | cut -d/ -f2),$(echo "$stats" | cut -d/ -f3)" >> $output_file
  else
    echo "$label,,," >> $output_file
  fi
}

# own public IP, included as required by the assignment
own_ip=$(curl -s https://api.ipify.org)
if [ -n "$own_ip" ]; then
  write_row "$own_ip" "$own_ip(self)"
fi

while read -r line; do
  # parse ip address from each line
  ip_host=$(echo $line | awk -F',' '{print $1}')
  write_row "$ip_host" "$ip_host"
done < $input_file
