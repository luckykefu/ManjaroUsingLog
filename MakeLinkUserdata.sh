rm -rf ~/.conda
ln -s /mnt/UserData/.conda ~/.conda
conda env list

# ssh
rm -fr ~/.ssh
ln -s /mnt/UserData/.ssh ~/.ssh

# vst
ln -s /mnt/UserData/.vst ~/.vst
ln -s /mnt/UserData/.vst3 ~/.vst3

rm -rf ~/Downloads
ln -s /mnt/UserData/Downloads ~/Downloads

rm -rf ~/Videos
ln -s /mnt/UserData/Videos ~/Videos

rm -rf ~/Music
ln -s /mnt/UserData/Videos ~/Music

rm -rf ~/Documents
ln -s /mnt/UserData/Documents ~/Documents

rm -rf ~/Pictures
ln -s /mnt/UserData/Pictures ~/Pictures
