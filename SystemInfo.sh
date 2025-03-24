#!/bin/bash
RED='\033[0;31m' #Sets Color to red
NC='\033[0m' # Default color back
echo -e "${RED}========== System Information ==========${NC}"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"

echo
echo -e "${RED}========== Memory Usage ==========${NC}"
free -h

echo
echo -e "${RED}========== Disk Usage ==========${NC}"
df -hT

echo
echo -e "${RED}========== Network Interfaces ==========${NC}"
ip -4 addr show | grep inet

echo
echo -e "${RED}========== Logged-in Users ==========${NC}"
who
