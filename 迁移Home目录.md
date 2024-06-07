---
created: '2024-05-06 '
---
挂载目标
```
# 挂载目标
sudo mount /dev/sdb1 /mnt
# 备份文件
sudo cp -av /home/ /mnt/
# 查看UUID
sudo blkid
# 修改fstab
sudo nano /etc/fstab
# 编辑
UUID=xxx /home ext4 default 0 2
# 验证
sudo mount -a
# 一切顺利则重启
```

