---
created: 2024-08-13
---
```

git clone https://aur.archlinux.org/snapd.git

cd snapd

makepkg -si

sudo systemctl enable --now snapd.socket

sudo systemctl start snapd

sudo systemctl enable --now snapd.apparmor.service

sudo ln -s /var/lib/snapd/snap /snap

sudo snap install onlyoffice-desktopeditors

```

