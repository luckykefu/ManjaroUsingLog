 # 排列源
sudo pacman-mirrors -i -c China -m rank


# 更新源列表
sudo pacman -Syy --noconfirm

# 增加cn仓库
sudo echo "[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.aliyun.com/archlinuxcn/\$arch" >> /etc/pacman.conf
# sudo nano /etc/pacman.conf

# 安装 archlinuxcn 签名钥匙 & antergos 签名钥匙
sudo pacman -Sy archlinuxcn-keyring haveged --noconfirm
sudo systemctl enable haveged
sudo pacman-key --init
sudo pacman-key --populate manjaro 
sudo pacman-key --populate archlinux
sudo pacman-key --populate archlinuxcn

# 升级系统
sudo pacman -Syyu --noconfirm


# Sudo 免密码
sudo echo "Defaults:$(logname) !authenticate" >> /etc/sudoers
# sudo nano /etc/sudoers


# 安装sudo pacman
sudo pacman -S  yay   base-devel ---noconfirm

# install 输入法
sudo pacman  -S manjaro-asian-input-support-fcitx5 fcitx5 fcitx5-configtool fcitx5-chinese-addons fcitx5-qt fcitx5-gtk --noconfirm
echo 'export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export LANG="zh_CN.UTF-8"
export LC_CTYPE="zh_CN.UTF-8"'  >  ~/.xprofile
# nano ~/.xprofile


sudo pacman -S obsidian --noconfirm

# Install Visual Studio Code
sudo pacman  -S visual-studio-code-bin --noconfirm


## syncthing
sudo pacman  -S syncthing --noconfirm

## Telegram
sudo pacman  -S telegram-desktop --noconfirm

## OBS Studio
sudo pacman -S obs-studio --noconfirm


## ffmpeg
sudo pacman  -S ffmpeg --noconfirm


# 终端代理 proxychains
sudo pacman -S proxychains-ng --noconfirm
sudo sed -i '$d' /etc/proxychains.conf
sudo sed -i '$d' /etc/proxychains.conf
sudo echo "socks4 192.168.43.1 1080" >>  /etc/proxychains.conf
# cat /etc/proxychains.conf


# docker
sudo pacman -S docker --noconfirm
sudo systemctl start docker.service 
sudo systemctl enable docker.service
sudo usermod -aG docker  $(logname)
sudo pacman -S docker-compose --noconfirm

# pandoc
sudo pacman -S pandoc   --noconfirm

sudo pacman -S nodejs npm --noconfirm
