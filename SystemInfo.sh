#!/bin/bash

echo "========== System Information =========="
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"

echo
echo "========== Memory Usage =========="
free -h

echo
echo "========== Disk Usage =========="
df -hT

echo
echo "========== Network Interfaces =========="
ip -4 addr show | grep inet

echo
echo "========== Logged-in Users =========="
who
