#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Check if iwlist is installed
if ! command -v iwlist &> /dev/null; then
  # Install iwlist
  echo -e "${RED}iwlist not found, installing...${NC}"
  sudo apt-get update
  sudo apt-get install wireless-tools
  echo -e "${GREEN}iwlist installed${NC}"
else
  echo -e "${GREEN}iwlist found${NC}"
fi

# Check if hcitool is installed
if ! command -v hcitool &> /dev/null; then
  # Install hcitool
  echo -e "${RED}hcitool not found, installing...${NC}"
  sudo apt-get update
  sudo apt-get install bluez
  echo -e "${GREEN}hcitool installed${NC}"
else
  echo -e "${GREEN}hcitool found${NC}"
fi

# Check if gnuplot is installed
if ! command -v gnuplot &> /dev/null; then
  # Install gnuplot
  echo -e "${RED}gnuplot not found, installing...${NC}"
  sudo apt-get update
  sudo apt-get install gnuplot
  echo -e "${GREEN}gnuplot installed${NC}"
else
  echo -e "${GREEN}gnuplot found${NC}"
fi

# Check if bluez-simple-agent is installed
if ! command -v bluez-simple-agent &> /dev/null; then
  # Install bluez-simple-agent
  echo -e "${RED}bluez-simple-agent not found, installing...${NC}"
  sudo apt-get update
  sudo apt-get install bluez-tools
  echo -e "${GREEN}bluez-simple-agent installed${NC}"
else
  echo -e "${GREEN}bluez-simple-agent found${NC}"
fi

# Check if aircrack-ng is installed
if ! command -v aircrack-ng &> /dev/null; then
  # Install aircrack-ng
  echo -e "${RED}aircrack-ng not found, installing...${NC}"
  sudo apt-get update
  sudo apt-get install aircrack-ng
  echo -e "${GREEN}aircrack-ng installed${NC}"
else
  echo -e "${GREEN}aircrack-ng found${NC}"
fi
# Make the script executable
chmod +x wardriver.sh

# Add a symbolic link to allow the script to be executed with just "./wardriver"
if [ ! -e wardriver ]; then
  ln -s wardriver.sh wardriver
else
  echo -e "${RED}Error: failed to create symbolic link 'wardriver': File exists${NC}" >&2
fi
