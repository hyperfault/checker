#!/bin/bash

set -e

echo "==> Checking system package updates..."
sudo pacman -Sy --needed --noconfirm > /dev/null

updates=$(pacman -Qu)
if [ -z "$updates" ]; then
    echo "All system packages are up-to-date ✅"
else
    echo "Updates available:"
    echo "$updates"

    read -p "Update all system packages now? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        sudo pacman -Syu
    else
        echo "Skipped system update."
    fi
fi

# AUR updates (if yay exists)
if command -v yay >/dev/null 2>&1; then
    echo "==> Checking AUR updates..."
    aur_updates=$(yay -Qua || true)
    if [ -z "$aur_updates" ]; then
        echo "All AUR packages are up-to-date ✅"
    else
        echo "AUR updates available:"
        echo "$aur_updates"

        read -p "Update all AUR packages now? (y/n): " aur_choice
        if [[ "$aur_choice" =~ ^[Yy]$ ]]; then
            yay -Syu
        else
            echo "Skipped AUR update."
        fi
    fi
fi
