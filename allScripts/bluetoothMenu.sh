#!/usr/bin/env bash

# Ensure bluetoothctl is available
if ! command -v bluetoothctl &> /dev/null; then
    echo "Error: bluetoothctl is not installed."
    exit 1
fi

# Get Bluetooth status
BT_STATE=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$BT_STATE" = "yes" ]; then
    TOGGLE="Turn Bluetooth Off"
elif [ "$BT_STATE" = "no" ]; then
    TOGGLE="Turn Bluetooth On"
fi

# List available devices (MAC + Name)
DEVICES=$(bluetoothctl devices | cut -d ' ' -f 2-)

# Show menu using tofi
CHENTRY=$(echo -e "$TOGGLE\nRescan\n$DEVICES" | tofi -c /home/fabioc/Documents/scripts/etc/tofi/tofi.conf --prompt-text "Bluetooth Devices:")

# Handle selection
if [ "$CHENTRY" = "Turn Bluetooth Off" ]; then
    bluetoothctl power off
    exit 0

elif [ "$CHENTRY" = "Turn Bluetooth On" ]; then
    bluetoothctl power on
    exit 0

elif [ "$CHENTRY" = "Rescan" ]; then
    bluetoothctl scan on &
    sleep 5
    bluetoothctl scan off
    exec "$0"
    exit 0

elif [ -n "$CHENTRY" ]; then
    DEVICE_MAC=$(echo "$CHENTRY" | awk '{print $1}')
    if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
        bluetoothctl disconnect "$DEVICE_MAC"
    else
        bluetoothctl connect "$DEVICE_MAC"
    fi
fi

