---
created: 2024-04-03T00:00:00.000Z
---

# Ssh使用指南

## Gitee 作例子

```
git config --global user.name 'kefu' 
git config --global user.email '3124568493@qq.com'
```

### 通过命令 ssh-keygen 生成 SSH Key

```
ssh-keygen -t ed25519 -C "git SSH Key"
```
-t key 类型  
-C 注释  
中间通过三次回车键确定  

#### 查看生成的 SSH 公钥和私钥

```
ls ~/.ssh/
```

私钥文件 id_ed25519  
公钥文件 id_ed25519.pub

#### 读取公钥文件 ~/.ssh/id_ed25519.pub

```
cat ~/.ssh/id_ed25519.pub
# 输出，如：

ssh-ed25519 AAAA***5B Gitee SSH Key
```

用户可以通过主页右上角「个人设置」->「安全设置」->「SSH 公钥」->「添加公钥」，添加生成的 public key 添加到当前账户中。

#### 通过 ssh -T 测试，输出 SSH Key 绑定的用户名

```
# username是你的用户名
ssh -T username@gitee.com

# Hi USERNAME! You've successfully authenticated, but GITEE.COM does not provide shell access.输出这个表示连接成功
```

#### 连接git remote

```
# 更改远程仓库 URL 为 SSH 格式：username是你的用户名，repo是你的仓库名
git remote set-url origin git@github.com:username/repo.git



```

#### 推送更改

```
git push origin master
```
