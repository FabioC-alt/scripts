#!/bin/bash

# Interrompe lo script se una qualsiasi operazione fallisce
set -e

# Funzione per visualizzare un messaggio di errore e interrompere lo script
error_exit() {
    echo "Errore: $1"
    exit 1
}

# Assicurati che lo script venga eseguito come root
if [[ $EUID -ne 0 ]]; then
    error_exit "Questo script deve essere eseguito come root"
fi

# Lista dei pacchetti
packages=(
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
)

# Aggiorna il database dei pacchetti e installa i pacchetti
if ! pacman -Syu --needed "${packages[@]}" --noconfirm; then
    error_exit "Errore nell'installazione dei pacchetti"
fi

# Esegui il "stow" per ogni cartella nella directory, gestendo 'chrome' separatamente
for dir in */; do
    if [[ "$dir" == "chrome/" ]]; then
        target_dir="$HOME/.mozilla/firefox/$(ls $HOME/.mozilla/firefox | grep '.default-release')/chrome"
    else
        target_dir="$HOME/.config/${dir%/}"
    fi
    
    # Crea la directory di destinazione se non esiste
    if ! mkdir -p "$target_dir"; then
        error_exit "Errore nella creazione della directory: $target_dir"
    fi

    # Esegui stow per creare i link simbolici
    if ! stow -t "$target_dir" "$dir"; then
        error_exit "Errore nell'eseguire stow per la directory: $dir"
    fi
done

# Copio contenuto di bashrc nella Home

cp bashrc ~/.bashrc

echo "Script completato con successo!"
