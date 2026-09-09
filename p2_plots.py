import os
os.environ["OPENBLAS_NUM_THREADS"] = "1"  # avoids a threading issue with numpy/matplotlib on this machine

import matplotlib.pyplot as pyplot
import matplotlib.cm as cm

with open("plot_files.txt", "r") as f:
  filenames = [line.strip() for line in f]

# Get data (hop count, latency) from each ip address's file and save to total_data{}
total_data = {}

for filename in filenames:
  hops = []
  latencies = []

  with open(filename, "r") as f:
    # Skip header line
    next(f)

    for line in f:
      hop, latency = line.strip().split(",")
      #print(f"HOP={hop} // LATENCY={latency}")
      hops.append(int(hop))

      if latency == "NONE":
        latencies.append(0)
      else:
        latencies.append(float(latency))

  total_data[filename] = {
    "hops": hops,
    "latencies": latencies
  }

# Create stacked bars in plot
fig, ax = pyplot.subplots(figsize=(18, 10))

x = range(len(filenames))
bottom = [0] * len(filenames)

max_hops = max(len(data["hops"]) for data in total_data.values())

colors = cm.rainbow(
  [i / max(1, max_hops - 1) for i in range(max_hops)]
)

for hop_index in range(max_hops):
  values = []

  for filename in filenames:
    data = total_data[filename]

    if hop_index < len(data["latencies"]):
      values.append(data["latencies"][hop_index])
    else:
      values.append(0)

  ax.bar(x, values, bottom=bottom, label=f"Hop {hop_index + 1}", color=colors[hop_index])
  # Move bottom up so that bars will actually stack on top of each other
  bottom = [
    bottom[i] + values[i]
    for i in range(len(values))
  ]

# Bar chart formatting
ax.set_xticks(x)
shortened_names = [
  filename.removesuffix(".csv")
  for filename in filenames
]

ax.set_xticklabels(shortened_names, rotation=45, ha="right")
ax.set_xlabel("IP Address")
ax.set_ylabel("Latency (ms)")
ax.set_title("Latency per Hop by IP Address")

ax.legend(title="Hop Number", bbox_to_anchor=(1.02, 1), loc="upper left")

fig.subplots_adjust(
  left=0.08,
  right=0.80,
  bottom=0.25,
  top=0.92
)

pyplot.tight_layout()
pyplot.savefig("traceroute_barchart.png")
print("-- Stacked bar chart has been saved to \"traceroute_barchart.png\" --")

# Scatterplot formatting
fig, ax = pyplot.subplots(figsize=(14, 8))

for filename, data in total_data.items():
  hops = []
  latencies = []

  for hop, latency in zip(data["hops"], data["latencies"]):
    if latency !=0:
      hops.append(hop)
      latencies.append(latency)

  ax.scatter(hops, latencies, label=filename.removesuffix(".csv"))

ax.set_xlabel("Hop Count")
ax.set_ylabel("RTT (ms)")
ax.set_title("RTT vs. Hop Count")

ax.legend(bbox_to_anchor=(1.02, 1), loc="upper left")

fig.tight_layout()

pyplot.savefig("traceroute_scatter.png")
print("-- Scatter plot has been saved to \"traceroute_scatter.png\" --")
