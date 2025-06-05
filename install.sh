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
    noto-fonts-emoji
    noto-fonts-cjk
    ttf-nerd-fonts-symbols
'

dev_mode_packages='
    docker
'

yay_packages='
    wl-kbptr
    wlrctl
'

# === Tofi Installation ===
echo 'Installing Tofi'
./allScripts/tofiInstallationScript.sh

# === Custom Script Setup ===
echo 'Setting up cpcl script'
mkdir -p ~/.local/bin
cp allScripts/cpcl.sh ~/.local/bin/cpcl
chmod +x ~/.local/bin/cpcl

# === Pacman Packages ===
echo 'Installing packages via pacman...'
sudo pacman -Syu --noconfirm
sudo pacman -S $packages --noconfirm

# === Stow Config ===
echo 'Stowing Folders'
stow -t $HOME/.config etc 

# === Bashrc Setup ===
echo 'Configuring bashrc'
cp configs/bashrc ~/.bashrc
source ~/.bashrc

# === Git Config ===
echo 'Configuring Github Credentials'
git config --global user.email "fabiociraci41@gmail.com"
git config --global user.name "FabioC-alt"

# === Systemd Timers ===
echo 'Configuring Systemd Timers'
mkdir -p ~/.config/systemd/user
cp systemd/* ~/.config/systemd/user/
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now gitPull.timer gitSync.timer

# === NetworkManager ===
echo 'Configuring Network Manager'
sudo systemctl enable --now NetworkManager

# === Timezone ===
echo 'Setting timezone to Europe/Rome'
sudo timedatectl set-timezone Europe/Rome

# === Bluetooth ===
echo 'Enabling Bluetooth'
sudo systemctl enable --now bluetooth

# === Greetd ===
echo 'Setting up Greetd'
sudo cp -r /home/$USER/Documents/scripts/boot/greetd /etc/greetd
sudo systemctl enable greetd

# === Docker ===
if [ "$docker_mode" = true ]; then
    echo "Installing Docker"
    sudo pacman -S $dev_mode_packages --noconfirm
    curl -sS https://webinstall.dev/k9s | bash

    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker $USER
else
    echo "Docker mode off"
fi

# === Clone Repos ===
if [ "$cloning_repo" = true ]; then
    echo "Cloning repositories..."
    cd ~/Documents
    git clone https://github.com/FabioC-alt/masterThesis
else
    echo "Repo cloning disabled"
fi

# === yay ===
if [ "$yay_mode" = true ]; then
    echo "Installing yay..."
    cd ~/Documents
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm

    echo "Installing yay packages..."
    yay -S $yay_packages --noconfirm
else
    echo "yay not installed, skipping AUR packages"
fi

# === TLDR ===
echo 'Updating tldr cache'
tldr --update

echo "✅ Successfully installed all components! Reboot to apply all changes."

