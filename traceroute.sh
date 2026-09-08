#!/bin/bash

input="listed_iperf3_servers.csv"

#echo "hops,lat" > hops1.csv

tail -n 1 $input | while IFS="," read -r ip other; do
  echo "hops,lat" > "$ip.csv"
  mapfile lines < <(traceroute -n -q 1 $ip | tail -n +2)
  for line in "${lines[@]}"; do
    IFS=" " read -r hops addr lat ms <<< $line
    if [[ "$addr" != "*" ]]; then
      echo "$hops,$lat" >> "$ip.csv"
    else
      echo "$hops,NONE" >> "$ip.csv"
    fi
  done
done
