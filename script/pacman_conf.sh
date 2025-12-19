#!/bin/bash
# ============================================================================
# Script: pacman_conf.sh
# Description: Configure pacman.conf with optimizations and archlinuxcn repo
# Logic: Adds Color, ILoveCandy, ParallelDownloads to [options] section,
#        configures archlinuxcn repository with mirror and signature settings
# ============================================================================
# 脚本: pacman_conf.sh
# 描述: 配置 pacman.conf 优化选项和 archlinuxcn 仓库
# 逻辑: 在 [options] 部分添加 Color、ILoveCandy、ParallelDownloads，
#        配置 archlinuxcn 仓库的镜像和签名设置
# ============================================================================

set -euo pipefail

#--> Configure pacman.conf options --> 配置 pacman.conf 选项
pacman_conf() {
    PACMAN_FILE=/etc/pacman.conf
    local SigLevel=${1:-"Optional TrustedOnly"} 
    local Server=${2:-"https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch"}   
    local options=(
        "Color"
        "ILoveCandy"
        "ParallelDownloads = 16"
    )
    
    #--> Configure pacman repo options --> 配置 options 选项
    for opt in "${options[@]}"; do
        #--> Extract key name --> 提取键名
        key=${opt%% *}

        #--> Delete matching line --> 删除匹配的行
        sudo sed -i "/^#\?$key/d" "$PACMAN_FILE"
        
        #--> Add new line under [options] --> 在 [options] 下添加新行
        sudo sed -i "/^\[options\]/a $opt" "$PACMAN_FILE"
    done

    local archlinuxcn=(
        "SigLevel = $SigLevel"
        "Server = $Server"
    )
    grep -q "^\[archlinuxcn\]" "$PACMAN_FILE" || echo -e "[archlinuxcn]" | sudo tee -a "$PACMAN_FILE" >/dev/null
    #--> Configure archlinuxcn repo options --> 配置 archlinuxcn 仓库选项
    for opt in "${archlinuxcn[@]}"; do
        #--> Extract key name --> 提取键名
        key=${opt%% *}
        echo "Processing: $key"

        #--> Delete matching line --> 删除匹配的行
        sudo sed -i "/^#\?$key/d" "$PACMAN_FILE"

        #--> Add new line under [archlinuxcn] --> 在 [archlinuxcn] 下添加新行
        sudo sed -i "/^\[archlinuxcn\]/a $opt" "$PACMAN_FILE"
    done

    echo "✓ pacman.conf configured"
    sudo pacman -Syy --noconfirm
}

#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    pacman_conf "$@"
fi
