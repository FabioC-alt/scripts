#!/bin/bash

docker_mode = 1
cloning_repo = 1

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
    wofi
    dunst
'

dev_mode_packages = '
    docker   
'

echo 'Installing Packages'
sudo pacman -S $packages --noconfirm

echo 'Creating Config Folders'
mkdir -p $HOME/.config/hypr
mkdir -p $HOME/.config/waybar
mkdir -p $HOME/.config/wofi
mkdir -p $HOME/.config/dunst
mkdir -p $HOME/.config/kitty

echo 'Stowing Folders'
sudo stow -t $HOME/.config/hypr hypr
sudo stow -t $HOME/.config/waybar waybar
sudo stow -t $HOME/.config/wofi wofi
sudo stow -t $HOME/.config/dunst dunst
sudo stow -t $HOME/.config/kitty kitty

echo 'Configuring bashrc'
cp bashrc ~/.bashrc
source ~/.bashrc

echo 'Configuring Github Credentials'
git config --global user.email "fabiociraci41@gmail.com"
git config --global user.name "FabioC-alt"

echo 'Configuring Network manager'
sudo systemctl enable NetworkManager

echo 'Setting timedatectl'
sudo timedatectl set-timezone Europe/Rome


if [ "$docker_mode" -eq 1]; then

   echo "Installing Docker"
   sudo pacman -S $dev_mode_packages
else
   echo "Docker mode off"

fi

# Check if the variable is set to 1
if [ "$cloning_repo" -eq 1 ]; then
  echo "Cloning repositories..."
  git clone https://github.com/FabioC-alt/AnalisiTrafficoBologna.git
  # Add more repositories as needed
else
  echo "Variable is not set to 1. Skipping repository cloning."
fi



echo "Successfully Installed all components"


