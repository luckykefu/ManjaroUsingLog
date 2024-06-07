---
created: "2024-04-25 "
tags:
  - resource
---
# Download & Install Manjaro
## Download
Download Link: [Manjaro Downloads](https://manjaro.org/download/)
## Make USB Live 
Software: Ventoy
```sh
# install
sudo pacman  -S ventoy --noconfirm

```
## Install from USB Live
# First run manjaro
## no kde wallet
## pacman-mirror 
```
sudo pacman-mirrors -i -c China -m rank
```
## Update mirror list
```
sudo pacman -Syy --noconfirm
```
## Add archlinuxcn mirror
```
sudo nano /etc/pacman.conf

# add to the bottom

[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch

```
## obsidian
```
sudo pacman -S obsidian --noconfirm
```
## Update mirror list
```
sudo pacman -Syy --noconfirm
```
## Install archlinuxcn key
```
sudo pacman -Sy archlinuxcn-keyring haveged --noconfirm
sudo systemctl enable haveged
sudo pacman-key --init
sudo pacman-key --populate manjaro 
sudo pacman-key --populate archlinux
sudo pacman-key --populate archlinuxcn
```
## Update system
```
sudo pacman -Syyu --noconfirm
```
## Sudo No Password
```
sudo nano  /etc/sudoers

logname # look who is login

Defaults:kf !authenticate # kf is login

```
## Chinese input
```
sudo pacman  -S manjaro-asian-input-support-fcitx5 fcitx5 fcitx5-configtool fcitx5-chinese-addons fcitx5-qt fcitx5-gtk --noconfirm

echo 'export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export LANG="zh_CN.UTF-8"
export LC_CTYPE="zh_CN.UTF-8"'  >  ~/.xprofile

nano ~/.xprofile
```
# Install Software
## 安装 yay
```
sudo pacman -S  yay  --noconfirm
```

## syncthing
```
sudo pacman  -S syncthing --noconfirm
```
## Telegram
```
sudo pacman  -S telegram-desktop --noconfirm

# data dir
sudo cp -r ./TelegramDesktop ~/.local/share/TelegramDesktop
```
## OBS Studio
```
sudo pacman -S obs-studio --noconfirm
```
## ffmpeg
```
sudo pacman  -S ffmpeg --noconfirm
```
## proxychains
```
sudo pacman -S proxychains-ng --noconfirm

sudo  nano  /etc/proxychains.conf

socks5 192.168.43.1 1080
```
## docker
```
sudo pacman -S docker --noconfirm
sudo systemctl enable docker.service
sudo usermod -aG docker  $(logname)
sudo pacman -S docker-compose --noconfirm
```
## pandoc
```
sudo pacman -S pandoc   --noconfirm
```
## nodejs npm  Docsify
```sh

sudo pacman -S nodejs npm --noconfirm

sudo npm install docsify-cli -g
```
## miniconda 3
```
sudo pacman -S base-devel --noconfirm
yay -S miniconda3 --noconfirm

sudo nano ~/.zshrc
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# openssl error
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
source ~/.zshrc

# pip mirror
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple

```
## chrome
```
yay -S google-chrome --noconfirm

# data dir
~/.config/google-chrome

```
## Visual Studio Code
```
yay -S vscode  --noconfirm
```
# Basic Config
## kde 5
- Alt+Space
	- 
- 外观
	- 全局主题
	- 字体
		- 思源
- 语言包
- 工作区行为
	- 点击滚动条空白位置
		- 直接
	- 屏幕边缘
		- 四分并排
			- 中间点
	- 桌面特效
	- 锁屏
		- 300 秒
	- 最近文件
		- 保存历史记录
			- 一个月
- 语言和区域
	- 日期
		- 自动
	- 输入法
		- shift 切换
- 输入设备
	- numlock
		- 打开
	- 触摸板
		- 轻触点击
		- 滚动
			- 反向
		- 右键点击
			- 任意位置
- 显卡
	- 缩放
- 可移动存储
	- 自动挂载
- 蓝牙
	- 
## kde 6
- Alt + Space
	- position on screen
		- center
	- history
		- disable
- mouse & touchpad
	- touchpad
		- scrolling
			- invert scrolling direction
		- right click
			- press anywhere
- keyboard
	- numlock
		- turn on
- bluetooth
	- disable
- disks & cameras
	- device auto mount

- colors & themes
	- dark
# Nvidia

```bash

sudo pacman -Syu

lspci -vnn | grep VGA
# see driver information

# download driver from official website 
[NVIDIA GeForce 驱动程序 - N 卡驱动 | NVIDIA](https://www.nvidia.cn/geforce/drivers/)
uname -r
# see kernel version and install 
sudo pacman -S base-devel dkms --noconfirm # install development tools

sudo pacman -S linux69-headers --noconfirm # install headers for kernel version
# set up grub 
sudo nano /etc/default/grub 
# modify the line to include the following: 
# GRUB_CMDLINE_LINUX="nouveau.modeset=0"

sudo update-grub
reboot

sudo sh  ./NVIDIA-Linux-*.run

nvidia-smi
reboot
```
# 常见问题处理
```bash
# 安装被锁定的问题
  sudo rm /var/lib/pacman/db.lck

# 无法注册数据库
  sudo mv /etc/lsb-release /etc/lsb-release.bak
  sudo rm -rf /etc/lsb-release.bak

# 无法提交处理（有冲突的文件）
  # 编辑 /etc/pacman.conf 文件，修改服务器地址
  sudo gedit /etc/pacman.conf

# 更新失败
  sudo pacman -Syu --ignore <package_name>
```
# 自动挂载磁盘
```
# 查看UUID
sudo blkid

# 创建挂载目录
sudo mkdir /mnt/data

# 修改fstab
sudo nano /etc/fstab

# 编辑
UUID=935cddf7-2ff4-4f60-8c24-5f89104f6b16 /mnt/data ext4 defaults 0 2

# 验证
sudo mount -a

# 一切顺利则重启
reboot

```
# 迁移大文件
##  .conda
```
# move ~/.conda folder to other 
sudo mv ~/.conda /mnt/data/UserData

# make link to ~.conda
sudo ln -s /mnt/data/UserData ~/.conda

```
# 备份文件
```
# google
~/.config/google-chrome
sudo cp ~/.config/google-chrome /mnt/data/UserData/ -r

# telegram
~/.local/share/TelegramDesktop
sudo cp ~/.local/share/TelegramDesktop /mnt/data/UserData/ -r

# dolphin
~/.config/dolphinrc
sudo cp ~/.config/dolphinrc /mnt/data/UserData/ -r

# firefox
~/.mozilla
sudo cp ~/.mozilla /mnt/data/UserData/ -r



```
# 生成 gpg 密钥
```
gpg --full-generate-key
```
# 系统备份&还原
## 备份

```bash
cd SystemBackup

echo "/proc
/sys
/dev
/tmp
/run
/mnt" > exclude.txt

sudo tar -cvpzf manjaroBackup.tar.gz --exclude-from=exclude.txt /
sudo tar -cvpzf manjaroHomeBackup.tar.gz /home
```

## 还原
### Boot from Live CD/USB
```sh

sudo mount /dev/sda2 /mnt

tar -xxpzf manjaroBackup.tar.gz -C /mnt

tar -xxpzf manjaroHomeBackup.tar.gz -C /mnt/home

# **Reconfigure the Bootloader**

for dir in /dev /dev/pts /proc /sys /run; do sudo mount --bind $dir /mnt$dir; done
    sudo chroot /mnt
    grub-install /dev/sda
    update-grub
```






# Notes

> 项目包含的笔记

项目包含的笔记

```dataviewjs
// 定义文件夹路径，这里需要你指定具体文件夹
let folderPath = dv.current().file.folder;

// 构建Markdown表格头
let headers = ["文件", "创建日期", "位置"]

// 检索指定文件夹下（包括子文件夹）的所有笔记
let files = dv.pages(`"${folderPath}"`)
    .sort(p => p.file.folder, 'asc');//排序条件：文件夹

// 生成表格数据
let tableData = files.map(p => [
    p.file.link, //有连接的文件名
    p.created, //文档frontmatter属性created
    p.file.path.substring(0, p.file.path.lastIndexOf('/')).split('/').pop() //文件所在文件夹
]);

// 生成Markdown格式表格
let table = dv.markdownTable(headers, tableData);

// 渲染Markdown表格
dv.paragraph(table);
```
