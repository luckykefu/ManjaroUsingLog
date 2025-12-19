#!/bin/bash
# ============================================================================
# Script: swapfile_conf.sh
# Description: Configure BTRFS swapfile with hibernation support
# Logic: Creates BTRFS swapfile, enables it, calculates resume offset,
#        updates GRUB config and fstab for hibernation support
# ============================================================================
# 脚本: swapfile_conf.sh
# 描述: 配置带休眠支持的 BTRFS 交换文件
# 逻辑: 创建 BTRFS 交换文件，启用它，计算恢复偏移量，
#        更新 GRUB 配置和 fstab 以支持休眠功能
# ============================================================================

set -euo pipefail

#--> Configure swapfile --> 配置交换文件
swapfile_conf() {
    local SIZE=${1:-"16g"}
    local SWAPFILE=${2:-"/swap/swapfile"}
    local SWAP_DIR=$(dirname "$SWAPFILE")
    
    #--> Create swap directory --> 创建交换文件目录
    sudo mkdir -p "$SWAP_DIR"
    
    #--> Create swapfile if not exists --> 如果交换文件不存在则创建
    if [[ ! -f "$SWAPFILE" ]]; then
        sudo btrfs filesystem mkswapfile --size "$SIZE" --uuid clear "$SWAPFILE"
        sudo chmod 600 "$SWAPFILE"
        echo "✓ Swapfile created"
    fi
    
    #--> Enable swapfile --> 启用交换文件
    if ! swapon --show | grep -q "$SWAPFILE"; then
        sudo swapon "$SWAPFILE"
        echo "✓ Swapfile enabled"
    fi
    
    #--> Get resume offset --> 获取休眠恢复偏移量
    local offset=$(sudo btrfs inspect-internal map-swapfile -r "$SWAPFILE")
    echo "Offset: $offset"
    
    #--> Update GRUB config --> 更新GRUB配置
    if ! grep -q "resume=" /etc/default/grub; then
        sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"resume=$SWAPFILE resume_offset=$offset /" /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo "✓ GRUB updated"
    fi
    
    #--> Update fstab --> 更新fstab
    if ! grep -q "$SWAPFILE" /etc/fstab; then
        echo "$SWAPFILE none swap defaults 0 0" | sudo tee -a /etc/fstab
        echo "✓ fstab updated"
    fi
    
    echo "✓ Swapfile configuration complete"
}

#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    swapfile_conf "$@"
fi
