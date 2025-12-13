#!/bin/bash
# btrfs_snapshot.sh

CONFIG=${1:-snapshot.conf}
[ -f "$CONFIG" ] && source "$CONFIG"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PARTITIONS=${PARTITIONS:-"/,/home,/data"}
READONLY=${READONLY:-true}
KEEP_DAYS=${KEEP_DAYS:-7}

for part in ${PARTITIONS//,/ }; do
    snap_dir="${part}/.snapshots"
    sudo mkdir -p "$snap_dir"
    
    [ "$READONLY" = true ] && RO="-r" || RO=""
    
    echo "快照: $part"
    sudo btrfs subvolume snapshot $RO "$part" "${snap_dir}/$(basename $part)_${TIMESTAMP}"
    
    # 删除旧快照
    find "$snap_dir" -maxdepth 1 -mtime +$KEEP_DAYS -exec sudo btrfs subvolume delete {} \;
done

echo "✓ 完成"
