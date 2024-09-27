# 排列源
sudo pacman-mirrors -i -c China -m rank


# 增加cn仓库
sudo echo "[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
# sudo nano /etc/pacman.conf

# 更新源列表
sudo pacman -Syy --noconfirm

sudo pacman -Sy obsidian --noconfirm

# 安装 archlinuxcn 签名钥匙 & antergos 签名钥匙
sudo pacman -Sy archlinuxcn-keyring haveged --noconfirm

sudo systemctl enable haveged

sudo systemctl start haveged

sudo rm -fr /etc/pacman.d/gnupg

sudo pacman-key --init

sudo pacman-key --populate manjaro

sudo pacman-key --populate archlinux

sudo pacman-key --populate archlinuxcn


# # Sudo 免密码
# # sudo echo "Defaults:$(logname) !authenticate" >> /etc/sudoers
# # sudo nano /etc/sudoers

# Update system
sudo pacman -Syyu --noconfirm

# 安装yay
sudo pacman -Sy  yay ---noconfirm

# install 输入法
sudo pacman  -Sy manjaro-asian-input-support-fcitx5 fcitx5 fcitx5-configtool fcitx5-chinese-addons fcitx5-qt fcitx5-gtk --noconfirm
echo "export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx"  >  ~/.xprofile

cat  ~/.xprofile

# Install Software
sudo pacman -Sy  yay  --noconfirm

sudo pacman -Sy  qbittorrent  --noconfirm

sudo pacman  -Sy telegram-desktop --noconfirm

sudo pacman -Sy obs-studio --noconfirm

sudo pacman  -Sy ffmpeg --noconfirm

sudo pacman -Sy nodejs npm --noconfirm

sudo pacman -Sy unzip-natspec --noconfirm

sudo pacman -Sy kdenlive  --noconfirm

sudo pacman -Sy android-tools --noconfirm

sudo pacman -Sy digikam --noconfirm

sudo pacman -Sy localsend --noconfirm

sudo pacman -Sy aria2 --noconfirm

sudo pacman -Sy  gimp --noconfirm

sudo pacman -Sy  krita --noconfirm


# docker
sudo pacman -Sy docker --noconfirm
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker  $(logname)
sudo pacman -Sy docker-compose --noconfirm


sudo pacman -Sy base-devel --noconfirm
