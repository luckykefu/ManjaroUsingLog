#!/bin/bash

#--> Add current directory to git repos list --> 将当前目录添加到 git 仓库列表
pwd_to_git_repos() {
    local f=${1:-"/data/.git_repos.conf"}
    local current_dir=$(pwd)
    
    #--> Create file if not exists --> 如果文件不存在则创建
    mkdir -p "$(dirname "$f")"
    touch "$f"
    
    #--> Check if path already exists --> 检查路径是否已存在
    if grep -qF "$current_dir" "$f"; then
        echo "✅ Path already in $f: $current_dir"
    else
        echo "$current_dir" >> "$f"
        echo "✅ Added to $f: $current_dir"
    fi
    
    echo ""
    echo "Current repos list:"
    cat "$f"
}

#--> Only execute when run directly --> 仅在直接运行时执行
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
    pwd_to_git_repos "$@"
fi
#--> End