#!/bin/bash

docker_mode=true
cloning_repo=true

# Lista dei pacchetti
packages='
    bash-completion
    github-cli
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
    tealdeer
    byobu
'

dev_mode_packages='
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

echo 'Setting bluetooth'
sudo systemctl enable bluetooth

if [ $docker_mode = true ]; then

   echo "Installing Docker"
   sudo pacman -S $dev_mode_packages --noconfirm
   curl -sS https://webinstall.dev/k9s | bash
else
   echo "Docker mode off"

fi

# Check if the variable is set to 1
if [ $cloning_repo = true ]; then
  echo "Cloning repositories..."
  cd /home/fabioc/Documents
  git clone https://github.com/FabioC-alt/MasterThesis
  # Add more repositories as needed
else
  echo "Variable is not set to 1. Skipping repository cloning."
fi

echo 'Config tldr'
tldr --update

echo "Successfully Installed all components"

