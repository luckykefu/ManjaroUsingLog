---
created: '2024-05-03 '
---
查看密码
```sh
jupyter notebook list
```
取消密码
```sh
jupyter notebook --generate-config
nano $HOME/$username.jupyter/jupyter_notebook_config.py
# 设置
c.NotebookApp.token = ''
```
