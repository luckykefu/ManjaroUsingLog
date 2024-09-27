---
created: '1970-01-01 '
tags:
  - resource
---
# Download & Install Manjaro

## Download ISO  Link

https://manjaro.org/download/

## Make USB Live

Software: Ventoy

```sh

sudo pacman -Sy ventoy --noconfirm

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
sudo pacman -Syy

sudo pacman -Sy obsidian --noconfirm

```
## Install archlinuxcn key

```

sudo pacman -Sy archlinuxcn-keyring haveged --noconfirm

sudo systemctl enable haveged

sudo systemctl start haveged

sudo rm -fr /etc/pacman.d/gnupg

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

# Install Software

```

sudo pacman -Sy  yay  --noconfirm

sudo pacman -Sy  qbittorrent  --noconfirm

sudo pacman  -Sy telegram-desktop --noconfirm

sudo pacman -Sy obs-studio --noconfirm

sudo pacman  -Sy ffmpeg --noconfirm

```

## docker

```

sudo pacman -Sy docker docker-compose --noconfirm

sudo systemctl enable docker.service

sudo systemctl start docker.service

sudo usermod -aG docker  $(logname)

sudo mkdir -p /sdb/Linux/docker

sudo mkdir -p /etc/docker/

sudo nano /etc/docker/daemon.json

sudo cp /etc/docker/daemon.json /sdb/Linux/dcoker-daemon.json

sudo systemctl daemon-reload

sudo systemctl restart docker

sudo systemctl start docker

sudo pacman -Rns docker docker-compose

sudo rm -rf /var/lib/docker

sudo rm -rf /var/lib/containerd

sudo rm -rf /etc/docker

sudo rm -rf /sdb/Linux/docker

```

## nodejs npm  Docsify

```sh


sudo pacman -Sy nodejs npm --noconfirm

sudo npm install docsify-cli -g

sudo pacman -Sy unzip-natspec --noconfirm

sudo pacman -Sy kdenlive  --noconfirm

sudo pacman -Sy android-tools --noconfirm

sudo pacman -Sy digikam --noconfirm

sudo pacman -Sy localsend --noconfirm

sudo pacman -Sy aria2 --noconfirm

sudo pacman -Sy  gimp --noconfirm

sudo pacman -Sy  krita --noconfirm

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

conda env list

```

## chrome

```

yay -Sy google-chrome --noconfirm

rm ~/.config/google-chrome -r


yay -Sy onlyoffice-desktopeditors --noconfirm

export all_proxy=socks5h://192.168.43.1:1088

yay -Sy visual-studio-code-bin --noconfirm

```

# Basic Config

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
- window management
	- desktop effects
		- 
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

## sdb

```

# 查看UUID

sudo blkid -s UUID -o value /dev/sdb1 

# 创建挂载目录

sudo mkdir /sdb

# 修改fstab

sudo nano /etc/fstab

# 编辑

UUID=4B1339065BB52449 /sdb ntfs-3g defaults 0 2

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

reboot

nvidia-smi

```

# 迁移Home目录

```sh

# makefs

sudo fdisk /dev/sdc

sudo mkfs.ext4 /dev/sdc1

# 查看UUID

# 挂载目标

sudo mkdir /newhome

sudo mount /dev/sdc1 /newhome

# 备份文件

sudo cp -av /home/* /newhome

sudo blkid

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
## 备份 Home

```

```

# 迁移大文件

```

rm -rf ~/.conda

ln -s /sdb/Linux/.conda ~/.conda

conda env list

rm -fr ~/.ssh

ln -s /sdb/.ssh ~/.ssh

mkdir /sdb/Linux/.vst

ln -s /sdb/Linux/.vst ~/.vst

mkdir /sdb/Linux/.vst3

ln -s /sdb/Linux/.vst3 ~/.vst3

source ~/.zshrc

echo "export PATH=\$PATH:/sdb/Linux/genymotion" >> ~/.zshrc

echo "export PATH=\$PATH:/sdb/Linux" >> ~/.zshrc

source ~/.zshrc

rm ~/.local/share/fonts
ln -s /sdb/Documents/MySyncData/Fonts ~/.local/share/fonts
fc-cache -vf ~/.local/share/fonts

rm -rf ~/Downloads
ln -s /sdb/Downloads ~/Downloads
rm -rf ~/Videos
ln -s /sdb/Videos ~/Videos
rm -rf ~/Music
ln -s /sdb/Music ~/Music
rm -rf ~/Documents
ln -s /sdb/Documents ~/Documents
rm -rf ~/Pictures
ln -s /sdb/Linux/Pictures ~/Pictures

rm -rf ~/下载
ln -s /sdb/Downloads ~/下载
rm -rf ~/视频
ln -s /sdb/Videos ~/视频
rm -rf ~/音乐
ln -s /sdb/Music ~/音乐
rm -rf ~/文档
ln -s /sdb/Documents ~/文档
rm -rf ~/图片
ln -s /sdb/Pictures ~/图片

```
# 使用代理启动软件
```

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

