# 排列源
sudo pacman-mirrors -i -c China -m rank

# 更新源列表
sudo pacman -Syy --noconfirm

# 增加cn仓库
sudo echo "[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
# sudo nano /etc/pacman.conf

# 安装 archlinuxcn 签名钥匙 & antergos 签名钥匙
sudo pacman -Sy archlinuxcn-keyring haveged --noconfirm
sudo systemctl enable haveged
sudo pacman-key --init
sudo pacman-key --populate manjaro
sudo pacman-key --populate archlinux
sudo pacman-key --populate archlinuxcn

sudo pacman -Sy obsidian --noconfirm

# # Sudo 免密码
# # sudo echo "Defaults:$(logname) !authenticate" >> /etc/sudoers
# # sudo nano /etc/sudoers


# 安装yay
sudo pacman -Sy  yay ---noconfirm

# install 输入法
sudo pacman  -Sy manjaro-asian-input-support-fcitx5 fcitx5 fcitx5-configtool fcitx5-chinese-addons fcitx5-qt fcitx5-gtk --noconfirm
echo "export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx"  >  ~/.xprofile

# nano ~/.xprofile


# Install Visual Studio Code
sudo pacman  -Sy visual-studio-code-bin --noconfirm

## Telegram
sudo pacman  -Sy telegram-desktop --noconfirm

## OBS Studio
sudo pacman -Sy obs-studio --noconfirm


## ffmpeg
sudo pacman  -Sy ffmpeg --noconfirm


# docker
sudo pacman -Sy docker --noconfirm
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker  $(logname)
sudo pacman -Sy docker-compose --noconfirm

sudo pacman -Sy nodejs npm --noconfirm

sudo pacman -Sy unzip  --noconfirm


# 升级系统
sudo pacman -Syyu --noconfirm
