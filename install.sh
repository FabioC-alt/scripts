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
    	zellij
    	lazygit
    	brightnessctl
    	ranger
    	libnotify
    	xdg-desktop-portal-hyprland 
    	hyprpaper
'

dev_mode_packages='
    docker 
'

echo 'Installing Packages'
sudo pacman -S $packages --noconfirm
sudo pacman -Syu


echo 'Stowing Folders'
stow -t $HOME/.config  etc 

echo 'Configuring bashrc'
cp configs/bashrc ~/.bashrc
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
   # Adding Docker to user group
   sudo groupadd docker
   sudo usermod -aG docker $USER

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

echo "Successfully Installed all components, reboot to start"
