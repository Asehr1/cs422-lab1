#!/bin/bash

input="listed_iperf3_servers.csv"

echo "ip,min,avg,max,lat,lon" > rtt.csv

tail +2 $input | while IFS="," read -r ip other; do
	location=$(curl "http://ip-api.com/csv/$ip?fields=status,lat,lon" 2>/dev/null)
	IFS="," read -r status lat lon <<< "$location"
	if [[ "$status" == "success" ]]; then
		ping $ip -c 10 -i 0.002 | grep 'min/avg/max' | awk -F '= ' '{print $2}' | awk -v ip=$ip -v lat=$lat -v lon=$lon -F '/' '{print ip "," $1 "," $2 "," $3 "," lat "," lon}' >> rtt.csv
	fi
done
