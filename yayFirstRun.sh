
# miniconda 3
yay -Sy miniconda3 --noconfirm

echo "[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh">>~/.zshrc

# openssl error

echo "export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1">>~/.zshrc

source ~/.zshrc

# pip mirror

pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple


yay -Sy google-chrome --noconfirm

yay -Sy kdenlive  --noconfirm

yay -Sy visual-studio-code-bin --noconfirm
