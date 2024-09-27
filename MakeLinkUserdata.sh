!/bin/bash
# ssh
# 检查当前目录下是否存在.ssh文件夹
if [ -d "$PWD/.ssh" ]; then
    # 检查是否存在~/.ssh文件夹
    if [ -d ~/.ssh ]; then
        read -p "~/.ssh文件夹已存在。是否删除? (y/n): " confirm
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
            rm -rf ~/.ssh
            echo "已删除 ~/.ssh 文件夹"
        else
            echo "操作已取消"
            exit 0
        fi
    fi
    # 创建软链接
    ln -sf "$PWD/.ssh" ~/.ssh
    echo "已创建 $PWD/.ssh 到 ~/.ssh 的软链接"
else
    echo "错误：当前目录下不存在 .ssh 文件夹"
    exit 1
fi

# 检查当前目录下是否存在.conda文件夹
if [ -d "$PWD/.conda" ]; then
    # 检查是否存在~/.conda文件夹
    if [ -d ~/.conda ]; then
        read -p "~/.conda文件夹已存在。是否删除? (y/n): " confirm
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
            rm -rf ~/.conda
            echo "已删除 ~/.conda 文件夹"
        else
            echo "操作已取消"
            exit 0
        fi
    fi
    # 创建软链接
    ln -sf "$PWD/.conda" ~/.conda
    echo "已创建 $PWD/.conda 到 ~/.conda 的软链接"
else
    echo "错误：当前目录下不存在 .conda 文件夹"
    exit 1
fi

conda env list

# vst
# 检查当前目录下是否存在.vst文件夹
if [ -d "$PWD/.vst" ]; then
    # 检查是否存在~/.vst文件夹
    if [ -d ~/.vst ]; then
        read -p "~/.vst文件夹已存在。是否删除? (y/n): " confirm
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
            rm -rf ~/.vst
            echo "已删除 ~/.vst 文件夹"
        else
            echo "操作已取消"
            exit 0
        fi
    fi
    # 创建软链接
    ln -sf "$PWD/.vst" ~/.vst
    echo "已创建 $PWD/.vst 到 ~/.vst 的软链接"
else
    echo "错误：当前目录下不存在 .vst 文件夹"
    exit 1
fi

# 检查当前目录下是否存在.vst3文件夹
if [ -d "$PWD/.vst3" ]; then
    # 检查是否存在~/.vst3文件夹
    if [ -d ~/.vst3 ]; then
        read -p "~/.vst3文件夹已存在。是否删除? (y/n): " confirm
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
            rm -rf ~/.vst3
            echo "已删除 ~/.vst3 文件夹"
        else
            echo "操作已取消"
            exit 0
        fi
    fi
    # 创建软链接
    ln -sf "$PWD/.vst3" ~/.vst3
    echo "已创建 $PWD/.vst3 到 ~/.vst3 的软链接"
else
    echo "错误：当前目录下不存在 .vst3 文件夹"
    exit 1
fi


# 检查 genymotion 目录是否存在
if [ -d "$PWD/genymotion" ]; then
    # 检查 PATH 中是否已经包含 genymotion 路径
    if ! grep -q "export PATH=\$PATH:$PWD/genymotion" ~/.zshrc; then
        echo "export PATH=\$PATH:$PWD/genymotion" >> ~/.zshrc
        echo "已将 $PWD/genymotion 添加到 PATH"
    else
        echo "PATH 中已包含 $PWD/genymotion，无需重复添加"
    fi
else
    echo "错误：$PWD 目录下不存在 genymotion 文件夹"
fi

# 避免在脚本中直接执行 source ~/.zshrc，因为这可能导致错误
echo "请手动运行 'source ~/.zshrc' 以应用更改"

# 检查当前目录是否已经在 PATH 中
if ! grep -q "export PATH=\$PATH:$PWD" ~/.zshrc; then
    echo "export PATH=\$PATH:$PWD" >> ~/.zshrc
    echo "已将当前目录 $PWD 添加到 PATH"
else
    echo "PATH 中已包含当前目录 $PWD，无需重复添加"
fi

# 提醒用户手动更新 shell 环境
echo "请手动运行 'source ~/.zshrc' 以应用更改"

# 检查 /sdb/Documents/MySyncData/Fonts 目录是否存在
if [ -d "$PWD/Fonts" ]; then
    # 检查 ~/.local/share/fonts 是否存在
    if [ -e ~/.local/share/fonts ]; then
        # 如果是目录，询问是否删除
        if [ -d ~/.local/share/fonts ]; then
            read -p "~/.local/share/fonts 目录已存在。是否删除? (y/n): " confirm
            if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                rm -rf ~/.local/share/fonts
                echo "已删除 ~/.local/share/fonts 目录"
            else
                echo "操作已取消"
                exit 0
            fi
        # 如果是符号链接，直接删除
        elif [ -L ~/.local/share/fonts ]; then
            rm ~/.local/share/fonts
            echo "已删除现有的 ~/.local/share/fonts 符号链接"
        else
            echo "~/.local/share/fonts 存在但既不是目录也不是符号链接。请手动检查并处理。"
            exit 1
        fi
    fi

    # 创建符号链接
    ln -s "$PWD/Fonts" ~/.local/share/fonts
    echo "已创建 $PWD/Fonts 到 ~/.local/share/fonts 的符号链接"

    # 更新字体缓存
    if command -v fc-cache &> /dev/null; then
        fc-cache -vf ~/.local/share/fonts
        echo "字体缓存已更新"
    else
        echo "警告：fc-cache 命令不可用，无法更新字体缓存"
    fi
else
    echo "错误：$PWD/Fonts 目录不存在"
    exit 1
fi
创建符号链接：Downloads, Videos, Music, Documents, Pictures

# 询问用户选择创建英文目录还是中文目录
echo "请选择要创建的目录类型："
echo "1. 英文目录 (Downloads, Videos, Music, Documents, Pictures)"
echo "2. 中文目录 (下载, 视频, 音乐, 文档, 图片)"
read -p "请输入选项 (1 或 2): " lang_choice

create_symlink() {
    local src="$1"
    local dest="$2"
    if [ ! -e "$src" ]; then
        echo "错误：源目录 $src 不存在"
        return
    fi
    if [ -e "$dest" ]; then
        if [ -d "$dest" ] && [ ! -L "$dest" ]; then
            read -p "$dest 目录已存在。是否删除? (y/n): " confirm
            if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                rm -rf "$dest"
                echo "已删除 $dest 目录"
            else
                echo "跳过 $dest 的符号链接创建"
                return
            fi
        elif [ -L "$dest" ]; then
            rm "$dest"
            echo "已删除现有的 $dest 符号链接"
        fi
    fi
    [ ! -e "$dest" ] && ln -s "$src" "$dest" && echo "已创建 $src 到 $dest 的符号链接"
}

if [ "$lang_choice" == "1" ]; then
    # 创建英文目录的符号链接
    create_symlink "$PWD/Downloads" ~/Downloads
    create_symlink "$PWD/Videos" ~/Videos
    create_symlink "$PWD/Music" ~/Music
    create_symlink "$PWD/Documents" ~/Documents
    create_symlink "$PWD/Pictures" ~/Pictures
    echo "英文目录符号链接创建完成"
elif [ "$lang_choice" == "2" ]; then
    # 创建中文目录的符号链接
    create_symlink "$PWD/Downloads" ~/下载
    create_symlink "$PWD/Videos" ~/视频
    create_symlink "$PWD/Music" ~/音乐
    create_symlink "$PWD/Documents" ~/文档
    create_symlink "$PWD/Pictures" ~/图片
    echo "中文目录符号链接创建完成"
else
    echo "无效的选项。请重新运行脚本并选择 1 或 2。"
    exit 1
fi
