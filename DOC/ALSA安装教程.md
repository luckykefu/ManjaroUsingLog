---
created: 2024-04-03T00:00:00.000Z
---

# ALSA安装教程

```sh
sudo pacman -Syu  
sudo pacman -S alsa-utils alsa-lib 
sudo systemctl start alsa  
sudo usermod -a -G audio kf  
dmesg | grep -i alsa
```
