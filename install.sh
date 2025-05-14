#!/bin/bash

yay_mode=true
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
	greetd
	greetd-tuigreet
'

dev_mode_packages='
	docker 
'

yay_packages='
	wl-kbptr
	wlrctl
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

echo 'Configuring Systemd Timers'
sudo cp systemd/* /etc/systemd/user/

echo 'Configuring Auto-git'
systemctl --user enable gitPull.timer
systemctl --user enable gitSync.timer

systemctl --user start gitPull.timer
systemctl --user start gitSync.timer

echo 'Configuring Network manager'
sudo systemctl enable NetworkManager

echo 'Setting timedatectl'
sudo timedatectl set-timezone Europe/Rome

echo 'Setting bluetooth'
sudo systemctl enable bluetooth

echo 'Setting Greetd'
cp /home/$USER/Documents/scripts/boot/greetd /etc/greetd
sudo systemctl enable greetd

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
  git clone https://github.com/FabioC-alt/masterThesis
  # Add more repositories as needed
else
  echo "Variable is not set to 1. Skipping"
fi

if [ $yay_mode = true ]; then
	echo "Installing yay..."
       	cd /home/$USER/Documents
	sudo pacman -S needed git base-devel
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si

	echo "Installing yay packages"
	yay -S $yay_packages 


else 	
	echo	"Not installing yay. Skipping"
fi




echo 'Config tldr'
tldr --update

echo "Successfully Installed all components, reboot to start"
