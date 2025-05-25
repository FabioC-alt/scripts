#!/usr/bin/env bash

# Optional: Rescan available SSIDs
# nmcli dev wifi rescan

FIELDS=SSID,SECURITY
LIST=$(nmcli --fields "$FIELDS" device wifi list | sed '/^--/d')
KNOWNCON=$(nmcli connection show)
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(LANG=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')
TOGGLE=""

if [[ "$CONSTATE" =~ "enabled" ]]; then
    TOGGLE="toggle off"
elif [[ "$CONSTATE" =~ "disabled" ]]; then
    TOGGLE="toggle on"
fi

# Build selection menu
CHENTRY=$(echo -e "$TOGGLE\nmanual\n$LIST" | uniq -u | tofi -c /home/fabioc/Documents/scripts/etc/tofi/tofi.conf --prompt-text "Wi-Fi SSID:")

CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/|/g' | awk -F "|" '{print $1}')

# Handle manual SSID entry
if [ "$CHENTRY" = "manual" ]; then
    read -p "Enter SSID: " MSSID
    read -s -p "Enter Password (or leave blank if open): " MPASS
    echo
    if [ -z "$MPASS" ]; then
        nmcli dev wifi con "$MSSID"
    else
        nmcli dev wifi con "$MSSID" password "$MPASS"
    fi

# Toggle Wi-Fi on/off
elif [ "$CHENTRY" = "toggle on" ]; then
    nmcli radio wifi on

elif [ "$CHENTRY" = "toggle off" ]; then
    nmcli radio wifi off

# Connect to selected network
else
    # Fix SSID if marked with "*"
    if [ "$CHSSID" = "*" ]; then
        CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/|/g' | awk -F "|" '{print $3}')
    fi
    if nmcli -t connection show | grep -q "^$CHSSID:"; then
        nmcli con up "$CHSSID"
    else
        if [[ "$CHENTRY" =~ "WPA2" || "$CHENTRY" =~ "WEP" ]]; then
            read -s -p "Enter Wi-Fi password for $CHSSID: " WIFIPASS
            echo
        fi
        nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
    fi
fi

