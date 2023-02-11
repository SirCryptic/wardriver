#!/bin/bash

## Developer: SirCryptic (NullSecurityTeam)
## Info: WarDriver 1.1 (BETA)
clear
echo -e "
___       __             ________       _____                    
__ |     / /_____ __________  __ \_________(_)__   ______________
__ | /| / /_  __ /_  ___/_  / / /_  ___/_  /__ | / /  _ \_  ___/
__ |/ |/ / / /_/ /_ /    _ /_/ /_  /   _  /  __|/ //  __/  /    
____/|__/  \___/ /_/    /_____/ /_/    /_/  _____/ \___//_/     
                                                                "

echo -e "
1. Scan for available wireless networks
2. Scan for available Bluetooth devices
3. Capture wireless handshakes"


read -p "Enter your choice (1, 2, or 3): " choice

if [ "$choice" == "1" ]; then
  echo "Scanning for available wireless networks..."

  # Use iwlist to scan for available wireless networks
  network_info=`iwlist wlan0 scan`

  # Use grep to filter for the ESSID (network name), address (MAC address), signal strength, and encryption type of each network
  network_names=`echo "$network_info" | grep ESSID | awk '{print $NF}'`
  network_addresses=`echo "$network_info" | grep Address | awk '{print $NF}'`
  signal_strengths=`echo "$network_info" | grep "Signal level" | awk '{print $4}' | awk -F= '{print $2}'`
  encryption_types=`echo "$network_info" | grep Encryption | awk '{print $NF}'`

  # Store the information in a file
  echo "$network_names $network_addresses $signal_strengths $encryption_types" > wireless_networks.txt

  echo "Scan complete, results stored in wireless_networks.txt."
  
  # Ask the user if they want to map the wireless networks
  read -p "Do you want to map the wireless networks? (y/n): " map_choice
  if [ "$map_choice" == "y" ]; then
    echo "Mapping the wireless networks..."
    
    # Use gnuplot to generate a plot of the signal strength of each network
    gnuplot << EOF
    set term png
    set output "wireless_network_map.png"
    set xlabel "Network Name"
    set ylabel "Signal Strength (dBm)"
    plot "wireless_networks.txt" using 1:3 with lines
EOF
    
    echo "Mapping complete, results stored in wireless_network_map.png."
  fi

elif [ "$choice" == "2" ]; then
  echo "Scanning for available Bluetooth devices..."

  # Use hcitool to scan for available Bluetooth devices
  bluetooth_devices=`hcitool scan`

  # Use awk to filter for the device address
  device_addresses=`echo "$bluetooth_devices" | awk '{print $1}'`

  # Store the information in a file
  echo "$device_addresses" > available_bluetooth_devices.txt

  echo "Scan complete, results stored in available_bluetooth_devices.txt."

  # Attempt to connect to each device in the stored file
  while read -r device_address; do
    echo "Attempting to connect to device with address $device_address..."

    # Use the bluez-simple-agent tool to connect to the device
    bluez-simple-agent hci0 "$device_address"

    # Check the return value of the previous command to see if the connection was successful
    if [ $? -eq 0 ]; then
      echo "Successfully connected to device with address $device_address."
    else
      echo "Failed to connect to device with address $device_address."
    fi
  done < available_bluetooth_devices.txt

elif [ "$choice" == "3" ]; then
  echo "Capturing wireless handshakes..."

  # Prompt the user to select the wireless interface to use
  echo "Available wireless interfaces:"
  iw dev | awk '$1=="Interface"{print $2}'
  read -p "Enter the name of the wireless interface to use: " interface

  # Define the name of the output file
  output_file="handshakes.pcap"

  # Stop any processes that may interfere with the capture process
  airmon-ng check kill

  # Start monitoring the wireless interface
  airmon-ng start $interface

  # Use airodump-ng to capture handshakes
  airodump-ng --output-format pcap --write $output_file mon0

  # Stop monitoring the wireless interface
  airmon-ng stop mon0

  # Convert the captured data to a format that can be used by aircrack-ng
  ivs_file="${output_file%.*}.ivs"
  ivs_tools -i $output_file -o $ivs_file

  # Prompt the user to enter the path to the wordlist file
  read -p "Enter the path to the wordlist file: " wordlist_path

  # Use aircrack-ng to crack any captured handshakes
  aircrack-ng -w "$wordlist_path" "$ivs_file"
else
  echo "Invalid choice, please enter 1, 2, or 3."
fi
