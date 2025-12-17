#!/bin/bash

# 清理孤儿包
clean(){
    # 清理孤儿包
    pacman -Qdtq | xargs -r sudo pacman -Rns --noconfirm
    # 清理旧版本缓存（保留最近版本）
    sudo pacman -Sc --noconfirm
    # 清理未使用的包
    sudo pacman -Qm --noconfirm | xargs -r sudo pacman -Rns --noconfirm
    # 清理缓存
    sudo pacman -Scc --noconfirm
    # 清理AUR缓存
    yay -Scc --noconfirm
    # 清理日志
    sudo journalctl --rotate
}
if [ "$0" == "${BASH_SOURCE[0]}" ]; then
    clean
fi
