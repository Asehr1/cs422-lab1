#!/bin/bash

input="listed_iperf3_servers.csv"

echo "hops,lat" > hops1.csv

tail -n 1 $input | while IFS="," read -r ip other; do
  tr=$(traceroute -n -q 1 $ip)
  tail -n +2 $tr | while IFS=" " read -r hops addr lat ms; do
    if [[ "$addr" != "*" ]]; then
      echo $hops","$lat >> hops1.csv
    fi
  done
done
