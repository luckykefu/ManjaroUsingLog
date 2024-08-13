sudo echo "UUID=935cddf7-2ff4-4f60-8c24-5f89104f6b16 /mnt ext4 defaults 0 2">>/etc/fstab

systemctl daemon-reload

sudo mount -a

