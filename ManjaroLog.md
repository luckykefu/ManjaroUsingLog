---
created: '2024-04-25 '
tags:
  - resource
---
# Download & Install Manjaro

## Download ISO
 [Manjaro Downloads](https://manjaro.org/download/)

## Make USB Live

Software: Ventoy

```sh

sudo pacman  -Sy ventoy --noconfirm

```

## Install from USB Live

# First run manjaro

## pacman-mirror

```

sudo pacman-mirrors -i -c China -m rank

```

## Add archlinuxcn mirror

```

sudo nano /etc/pacman.conf

[archlinuxcn]

SigLevel = Optional TrustAll

Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch

```
## obsidian

```

sudo pacman -Sy obsidian --noconfirm

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

sudo pacman  -Sy manjaro-asian-input-support-fcitx5 fcitx5 fcitx5-configtool fcitx5-chinese-addons fcitx5-qt fcitx5-gtk --noconfirm

echo 'export GTK_IM_MODULE=fcitx

export QT_IM_MODULE=fcitx

export XMODIFIERS=@im=fcitx'  >  ~/.xprofile

cat  ~/.xprofile

# 设置标点半角

```
## font
```bash
# 文泉驿
sudo pacman -S wqy-bitmapfont wqy-microhei wqy-microhei-lite wqy-zenhei
# 思源字体
sudo pacman -S noto-fonts-cjk adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
```
# Install Software

##  yay

```

sudo pacman -Sy  yay  --noconfirm

```
## qbittorrent
```
sudo pacman -Sy  qbittorrent  --noconfirm
```
## Telegram

```

sudo pacman  -Sy telegram-desktop --noconfirm

```

## OBS Studio

```

sudo pacman -Sy obs-studio --noconfirm

```

## ffmpeg

```

sudo pacman  -Sy ffmpeg --noconfirm

```

## docker

```

sudo pacman -Sy docker --noconfirm

sudo systemctl enable docker.service

sudo usermod -aG docker  $(logname)

sudo pacman -Sy docker-compose --noconfirm

sudo mkdir -p /etc/docker

sudo nano /etc/docker/daemon.json

{

"registry-mirrors": [
"https://quay.mirrors.ustc.edu.cn",
]

}

```

## nodejs npm  Docsify

```sh

sudo pacman -Sy nodejs npm --noconfirm

sudo npm install docsify-cli -g

```
## unzip

```

sudo pacman -Sy unzip  --noconfirm

```

## kdenlive

```

sudo pacman -Sy kdenlive  --noconfirm

```
## GIMP
```
sudo pacman -Sy  gimp --noconfirm
```
## krita
```
sudo pacman -Sy  krita --noconfirm
```
# yay
## miniconda 3

```

sudo pacman -Sy base-devel --noconfirm

yay -Sy miniconda3 --noconfirm

echo "[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh">>~/.zshrc

# openssl error

echo "export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1">>~/.zshrc

source ~/.zshrc

cat ~/.zshrc

# pip mirror

pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple

```

## chrome

```

yay -Sy google-chrome --noconfirm

# data dir

~/.config/google-chrome

```

## Visual Studio Code

```

yay -Sy visual-studio-code-bin --noconfirm

```
## sublime
```
yay -Sy sublime-text --noconfirm
```

## blender
```
yay -Sy  blender --noconfirm
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
		- pointer speed
			- 0.6
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
	- uttely sweet
	- cursors
	- dark
- screed locking
	- lock screen automaticallly
		- no
- recent files
	- keep history
		- 1 month
- energy saving
	- after a period of inactivity
		- do nothing
dolphin

# 自动挂载磁盘
## mnt
```

# 查看UUID

sudo blkid

# /dev/sdb1: UUID="935cddf7-2ff4-4f60-8c24-5f89104f6b16"

# 创建挂载目录

sudo mkdir /mnt

# 修改fstab

sudo nano /etc/fstab

# 编辑

UUID=935cddf7-2ff4-4f60-8c24-5f89104f6b16 /mnt ext4 defaults 0 2

# 验证
systemctl daemon-reload

sudo mount -a

# 一切顺利则重启

reboot
```
## vbox
```
# 创建挂载目录

sudo mkdir /vbox

sudo blkid

# 修改fstab

sudo nano /etc/fstab

# 编辑

UUID=a75412d0-be20-4bb9-aeef-221f94690c80 /vbox ext4 defaults 0 2

# 验证
systemctl daemon-reload

sudo mount -a

# 一切顺利则重启

reboot
```

# Nvidia
## auto 
```

sudo mhwd -a pci nonfree 0300
```
## hand
```bash

sudo pacman -Syu

lspci -vnn | grep VGA

# see driver information

# download driver from official website

[NVIDIA GeForce 驱动程序 - N 卡驱动 | NVIDIA](https://www.nvidia.cn/geforce/drivers/)

# see kernel version and install

uname -r

# install development tools

sudo pacman -Sy base-devel dkms --noconfirm

# install headers for kernel version

sudo pacman -Sy linux69-headers --noconfirm

# set up grub

sudo nano /etc/default/grub

# modify the line to include the following:

# GRUB_CMDLINE_LINUX="nouveau.modeset=0"

sudo update-grub

reboot

sudo sh  ./NVIDIA-Linux-*.run

reboot

nvidia-smi

sudo pacman -S cuda cudnn
sudo nano ~/.zshrc

export CUDA_HOME=/opt/cuda
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH

source ~/.zshrc

```

# 迁移Home目录

```sh

# makefs

sudo fdisk /dev/sdc

g

n

w

sudo mkfs.ext4 /dev/sdc1

# 查看UUID

# 挂载目标
sudo mkdir /newhome

sudo mount /dev/sdc1 /newhome

# 备份文件

sudo cp -av /home/* /newhome

sudo blkid

# /dev/sdc1: UUID="dde0cda6-fed0-48d4-b0fc-85282e50805c"

# 修改 fstab

sudo nano /etc/fstab

# 编辑

UUID=dde0cda6-fed0-48d4-b0fc-85282e50805c /home ext4 defaults 0 2

# 验证
systemctl daemon-reload

sudo mount -a

# 一切顺利则重启

reboot
```

# 迁移大文件

```

rm -rf ~/.conda
ln -s /mnt/UserData/.conda ~/.conda
conda env list

# ssh

rm -fr ~/.ssh
ln -s /mnt/UserData/.ssh ~/.ssh

# vst

ln -s /mnt/UserData/.vst ~/.vst
ln -s /mnt/UserData/.vst3 ~/.vst3

# ollama
rm -rf ~/.ollama
ln -s /mnt/UserData/.ollama ~/.ollama

rm -rf ~/Downloads
ln -s /mnt/UserData/Downloads ~/Downloads

rm -rf ~/Videos
ln -s /mnt/UserData/Videos ~/Videos

rm -rf ~/Music
ln -s /mnt/UserData/Music ~/Music

rm -rf ~/Documents
ln -s /mnt/UserData/Documents ~/Documents

rm -rf ~/Pictures
ln -s /mnt/UserData/Pictures ~/Pictures

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

# Notes

> 项目包含的笔记

```dataviewjs

// 定义文件夹路径，这里需要你指定具体文件夹

let folderPath = dv.current().file.folder;

// 构建Markdown表格头

let headers = ["文件", "创建日期", "位置"]

// 检索指定文件夹下（包括子文件夹）的所有笔记

let files = dv.pages(`"${folderPath}"`)

.

sort(p => p.file.folder, 'asc');//排序条件：文件夹

// 生成表格数据

let tableData = files.map(p => [

p

.file.link, //有连接的文件名

p

.created, //文档frontmatter属性created

p

.file.path.substring(0, p.file.path.lastIndexOf('/')).split('/').pop() //文件所在文件夹

]);

// 生成Markdown格式表格

let table = dv.markdownTable(headers, tableData);

// 渲染Markdown表格

dv.paragraph(table);

```

