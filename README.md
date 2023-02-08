# wardriver
bash script to automate wardriving tasks.

![image](https://user-images.githubusercontent.com/48811414/217430998-6e4668c5-c4ae-4207-a21e-0d227d47c5ce.png)


1) scan for available wireless networks and filters the results using grep and awk to obtain the network name (ESSID), address (MAC address), signal strength, and encryption type of each network. The results are stored in a file "wireless_networks.txt". The user is then prompted if they want to map the wireless networks, and if they choose "y", a plot of the signal strength of each network is generated using gnuplot and saved in a file "wireless_network_map.png".

2) scans available Bluetooth devices using hcitool command and filters the results using awk to obtain the device addresses. The results are stored in a file "available_bluetooth_devices.txt", The script will then attempt to connect to each device in the stored file using the bluez-simple-agent tool and print a message indicating whether the connection was successful or not.


# FOOT NOTE
You can also find this script in my script-dumping-ground repository [HERE ](https://github.com/SirCryptic/script-dumping-ground)
