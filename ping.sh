#!/bin/bash

input="listed_iperf3_servers.csv"

echo "ip,min,avg,max,lat,lon" > rtt.csv

ping_and_record() {
	local ip="$1"
	local location status lat lon
	location=$(curl -s "http://ip-api.com/csv/$ip?fields=status,lat,lon" 2>/dev/null)
	IFS="," read -r status lat lon <<< "$location"
	if [[ "$status" == "success" ]]; then
		ping $ip -c 10 -i 0.002 | grep 'min/avg/max' | awk -F '= ' '{print $2}' | awk -v ip=$ip -v lat=$lat -v lon=$lon -F '/' '{print ip "," $1 "," $2 "," $3 "," lat "," lon}' >> rtt.csv
	fi
}

# own public IP, included as required by the assignment
own_ip=$(curl -s https://api.ipify.org)
if [ -n "$own_ip" ]; then
	ping_and_record "$own_ip"
fi

while IFS="," read -r ip other; do
	ping_and_record "$ip"
done < "$input"
