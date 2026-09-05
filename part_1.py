import requests
import subprocess
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def haversine(lat1,lon1,lat2,lon2):
    lat1, lon1, lat2, lon2 = map(np.radians, [lat1,lon1,lat2,lon2])
    lat_diff = lat2-lat1
    lon_diff = lon2-lon1
    a = np.sin(lat_diff/2)**2 + np.cos(lat1) * np.cos(lat2) * np.sin(lon_diff/2)**2
    c = 2 * np.arcsin(np.sqrt(a))
    radius = 6371
    return radius * c

my_ip = requests.get("https://api.ipify.org").text
my_status, my_lat, my_lon = requests.get(f"http://ip-api.com/csv/{my_ip}?fields=status,lat,lon").text.split(",")

if my_status != "success":
    print("could not get your location")
    sys.exit(0)
my_lat=float(my_lat)
my_lon=float(my_lon)

subprocess.call("./ping.sh")

df = pd.read_csv("rtt.csv")

df["distance"] = haversine(my_lat, my_lon, df["lat"], df["lon"])

fig, axs = plt.subplots(1, 3, sharey=True)

times = ["min", "avg", "max"]
colors = ["green", "yellow", "red"]

for ax, time, color in zip(axs, times, colors):
    ax.scatter(df["distance"], df[time], alpha=0.5, edgecolors="black", color=color)
    ax.set_xlabel("Distance (km)")
    ax.set_title(f"{time.upper()} RTT vs. Distance")
axs[0].set_ylabel("RTT (ms)")
plt.tight_layout()
plt.savefig("rtt_vs_distance.pdf")
