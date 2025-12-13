#!/bin/bash
# autoset_swapfile.sh

CONFIG_FILE="${1:-swapfile.conf}"  # 配置文件路径

# 加载配置文件
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"          # 导入配置
else
    # 默认值
    SIZE=${SIZE:-16g}
    SWAPFILE=${SWAPFILE:-/swap/swapfile}
fi

SWAP_DIR=$(dirname "$SWAPFILE")

# 如果交换文件不存在则创建
if [ ! -f "$SWAPFILE" ]; then               # 检查文件是否不存在
    sudo mkdir -p "$SWAP_DIR"               # 创建目录（如果不存在）
    sudo btrfs filesystem mkswapfile --size "$SIZE" --uuid clear "$SWAPFILE"  # 创建Btrfs交换文件
    sudo chmod 600 "$SWAPFILE"              # 设置权限为仅所有者可读写
fi

# 如果交换文件未激活则启用
if ! swapon --show | grep -q "$SWAPFILE"; then  # 检查交换文件是否已启用
    sudo swapon "$SWAPFILE"                 # 启用交换文件
fi

# 获取休眠恢复偏移量
OFFSET=$(sudo btrfs inspect-internal map-swapfile -r "$SWAPFILE")  # 获取物理偏移量

# 如果GRUB配置中没有resume参数则添加
if ! grep -q "resume=" /etc/default/grub; then  # 检查是否已有resume参数
    sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"resume=$SWAPFILE resume_offset=$OFFSET /" /etc/default/grub  # 在内核参数中添加resume信息
    sudo grub-mkconfig -o /boot/grub/grub.cfg  # 重新生成GRUB配置
fi

# 如果fstab中没有交换文件条目则添加
if ! grep -q "$SWAPFILE" /etc/fstab; then  # 检查fstab是否已有此条目
    echo "$SWAPFILE none swap defaults 0 0" | sudo tee -a /etc/fstab  # 添加到fstab实现开机自动挂载
fi

echo "✓ 交换文件设置完成"                   # 输出完成信息
