#!/bin/bash
update() {
    sudo pacman -Syyu --noconfirm
    yay -Syyu --noconfirm
}

if [ "$0" == "${BASH_SOURCE[0]}" ]; then
    update
fi
