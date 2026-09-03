input_file="listed_iperf3_servers.csv"
output_file="ping_stats.txt"

# delete stats file if it already exists
if [ -f $output_file ]; then
  rm $output_file
fi

echo "ip_host,min_rtt_ms,avg_rtt_ms,max_rtt_ms,lat,lon" >> $output_file

ping_stats() {
  # runs ping and extracts "min/avg/max" from the summary line (works for
  # both Linux "rtt min/avg/max/mdev" and macOS "round-trip min/avg/max/stddev")
  ping -c 5 -i 0.005 "$1" 2>/dev/null | grep -oE '[0-9.]+/[0-9.]+/[0-9.]+' | head -n1
}

geo_lookup() {
  # looks up "lat,lon" for an ip via ip-api.com (free, no key needed)
  local json
  json=$(curl -s "http://ip-api.com/json/$1?fields=status,lat,lon")
  if echo "$json" | grep -q '"status":"success"'; then
    lat=$(echo "$json" | grep -oE '"lat":[-0-9.]+' | cut -d: -f2)
    lon=$(echo "$json" | grep -oE '"lon":[-0-9.]+' | cut -d: -f2)
    echo "$lat,$lon"
  fi
}

write_row() {
  # pings and geolocates $1, writes a CSV row labeled $2:
  # label,min,avg,max,lat,lon (blank fields if unresponsive/unlocatable)
  local host="$1"
  local label="$2"
  local stats geo
  stats=$(ping_stats "$host")
  geo=$(geo_lookup "$host")
  if [ -n "$stats" ]; then
    echo "$label,$(echo "$stats" | cut -d/ -f1),$(echo "$stats" | cut -d/ -f2),$(echo "$stats" | cut -d/ -f3),${geo:-,}" >> $output_file
  else
    echo "$label,,,,${geo:-,}" >> $output_file
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
