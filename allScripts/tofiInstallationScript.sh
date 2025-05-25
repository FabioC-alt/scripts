#!/bin/bash
set -e

sudo pacman -Sy

sudo pacman -S --noconfirm freetype2 harfbuzz cairo pango wayland libxkbcommon

sudo pacman -S --noconfirm meson scdoc wayland-protocols

cd ~/Documents

git clone https://github.com/philj56/tofi.git 
cd tofi

meson build && ninja -C build install

cd ~/Documents

rm -rf tofi/
