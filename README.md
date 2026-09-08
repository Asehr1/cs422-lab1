# CS 422 Assignment 1

**Setup Instructions**
1. Clone the repo
1. Navigate to the repo's top-level directory
1. Create and activate Python virtual environment<br>*python3 -m venv .venv*<br>*source .venv/bin/activate*
1. Install required packages<br>*pip install -r requirements.txt*

**TODO: need to combine scripts for both part 1 and part 2 into a single script. Maybe we can change script.sh to be the single script that handles venv, required packeges, and running both part's scripts?**

**Question 1** \
Script File: *part_1.py* \
Scatterplot: *rtt_vs_distance.pdf* \

**Question 2** \
Script File: \
Bar Chart: \
Scatterplot: \


---

## Report

GitHub repo: https://github.com/Asehr1/cs422-lab1

### Part 1: Ping Test and Round-Trip Time (RTT)

**Data collection.** For every IP in `listed_iperf3_servers.csv` (190 iperf3 servers), plus our own public IP,
we ran a ping test and looked up geolocation coordinates. See:
- Ping (min/avg/max RTT extraction) and geolocation lookup: [`ping.sh`](ping.sh)
- Distance calculation (haversine formula): [`part_1.py` lines 7-14](part_1.py#L7-L14)
- Scatter plot generation: [`part_1.py` lines 31-42](part_1.py#L31-L42)

Of the 191 hosts (190 servers + self), 187 responded to ping and 190 were geolocatable; 185 hosts had
both RTT and location data and are plotted below.

**Plot:** [`rtt_vs_distance.pdf`](rtt_vs_distance.pdf)
