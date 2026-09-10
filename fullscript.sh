#!/bin/bash

echo "Creating Python virtual environment"
python3 -m venv .venv

echo "Activating Python virtual environment"
source .venv/bin/activate

echo "Installing required packages"
pip install -r requirements.txt

echo "Running part 1"
./ping.sh
python3 part_1.py

echo "Running part 2"
./traceroute.sh
python3 p2_plots.py
