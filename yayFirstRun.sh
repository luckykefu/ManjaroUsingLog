# Ventoy
yay  -S Ventoy --noconfirm

# conda
yay -S miniconda3 --noconfirm
echo "if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh" >> /home/$(logname)/.zshrc
source ~/.zshrc
# sudo echo /home/$(logname)/.zshrc
echo "[global]
index-url = https://mirrors.aliyun.com/pypi/simple/
trusted-host = mirrors.aliyun.com" > /home/$(logname)/.pip/pip.conf

yay -S google-chrome --noconfirm

