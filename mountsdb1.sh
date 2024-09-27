#!/bin/bash
if [ ! -d "/sdb" ]; then
    sudo mkdir /sdb
fi


# 获取 /dev/sdb1 的 UUID
UUID=$(sudo blkid -s UUID -o value /dev/sdb1)

# 检查 UUID 是否成功获取
if [ -z "$UUID" ]; then
    echo "无法获取 /dev/sdb1 的 UUID"
    exit 1
fi

# 定义挂载点和文件系统类型
MOUNT_POINT="/sdb"
FILE_SYSTEM_TYPE="ntfs-3g"  # 根据实际情况修改文件系统类型

# 创建挂载点（如果不存在）
if [ ! -d "$MOUNT_POINT" ]; then
    sudo mkdir -p "$MOUNT_POINT"
fi

# 检查 fstab 中是否已存在该条目
if grep -q "$UUID" /etc/fstab; then
    echo "UUID $UUID 已存在于 /etc/fstab 中"
else
    # 添加到 /etc/fstab
    echo "UUID=$UUID $MOUNT_POINT $FILE_SYSTEM_TYPE defaults 0 2" | sudo tee -a /etc/fstab
    echo "已将 UUID $UUID 添加到 /etc/fstab"
fi
sudo systemctl daemon-reload 
# 挂载文件系统
sudo mount -a