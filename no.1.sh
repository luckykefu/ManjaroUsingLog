# sudo no password
sudo grep -q "^$USER ALL=(ALL) NOPASSWD: ALL" /etc/sudoers || echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
# restart vscode

# install miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh      
rm -rf $(pwd)/bin/miniconda3
sh ./Miniconda3-latest-Linux-x86_64.sh -b -p $(pwd)/bin/miniconda3
# Initialize conda for zsh
$(pwd)/bin/miniconda3/bin/conda init zsh
rm ./Miniconda3-latest-Linux-x86_64.sh
source ~/.zshrc
# Add conda-forge channel for more packages
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
conda install jupyter ipykernel -y
# restart vscode