#!/bin/bash

# Lista dei pacchetti
packages='
    ttf-font-awesome
    stow
    wl-clipboard
    grim
    slurp
    hyprlock
    hyprland
    hypridle
    waybar
    nano
    bluez
    bluez-utils
    blueman
    mcfly
    kitty
    firefox
    nautilus
'

echo 'Installing Packages'
sudo pacman -S $packages --noconfirm

echo 'Creating Config Folders'
mkdir -p $HOME/.config/hypr
mkdir -p $HOME/.config/waybar
mkdir -p $HOME/.config/wofi

echo 'Stowing Folders'
sudo stow -t $HOME/.config/hypr hypr
sudo stow -t $HOME/.config/waybar waybar
sudo stow -t $HOME/.config/wofi wofi

echo 'Configuring bashrc'
cp bashrc ~/.bashrc
source ~/.bashrc

echo 'Configuring Github Credentials'
git config --global user.email "fabiociraci41@gmail.com"
git config --global user.name "FabioC-alt"

echo 'Configuring Network manager'
sudo systemctl enable NetworkManager

echo "Successfully Installed all components"
