#!/bin/bash  # 指定使用bash解释器的shebang行

manage_links() {  # 定义管理符号链接的函数
    local source_dir="$1"  # 获取源目录参数
    local target_dir="$2"  # 获取目标目录参数
    
    source_dir=$(realpath "$source_dir")  # 将源目录转换为绝对路径
    
    # 检查并创建目标目录
    if [[ ! -d "$target_dir" ]]; then  # 检查目标目录是否存在
        mkdir -p "$target_dir"  # 创建目标目录及其父目录
        echo "Created target directory: $target_dir"  # 打印创建消息
    fi
    target_dir=$(realpath "$target_dir")  # 将目标目录转换为绝对路径
    
    # 1. 列出源目录中的目录（包括隐藏目录）
    local dirs=()  # 初始化目录数组
    shopt -s dotglob  # 启用隐藏文件匹配
    for d in "$source_dir"/*; do  # 遍历源目录中的所有项目
        if [[ -d "$d" && "$(basename "$d")" != "." && "$(basename "$d")" != ".." ]]; then  # 检查是否是目录且不是.或..
            dirs+=($(basename "$d"))  # 添加目录名到数组
        fi
    done
    shopt -u dotglob  # 禁用隐藏文件匹配
    echo "Found ${#dirs[@]} directories"  # 打印找到的目录数量
    
    # 4. 创建链接
    for dir in "${dirs[@]}"; do  # 遍历目录数组
        local src="$source_dir/$dir"  # 构建源路径
        local tgt="$target_dir/$dir"  # 构建目标路径
        echo -e "\n$src -> $tgt"  # 打印当前正在处理的映射
        
        if [[ -L "$tgt" ]]; then  # 检查目标是否已经是符号链接
            if [[ "$(readlink -f "$tgt")" == "$src" ]]; then  # 检查链接是否指向正确的源
                echo "✓ Link exists"  # 如果链接正确则打印成功消息
                continue  # 跳到下一次迭代
            fi
            rm "$tgt"  # 删除错误的符号链接
        elif [[ -f "$tgt" ]]; then  # 检查目标是否是普通文件
            read -p "Delete file $tgt? [Y/n]: " answer  # 询问用户是否确认删除文件
            if [[ "$answer" =~ ^[Yy]?$ ]]; then  # 检查用户回答
                rm "$tgt"  # 删除文件
            else  # 如果用户拒绝
                continue  # 跳到下一次迭代
            fi
        elif [[ -d "$tgt" ]]; then  # 检查目标是否是目录
            read -p "Delete dir $tgt? [Y/n]: " answer  # 询问用户是否确认删除目录
            if [[ "$answer" =~ ^[Yy]?$ ]]; then  # 检查用户回答
                rm -rf "$tgt"  # 删除目录及其所有内容
            else  # 如果用户拒绝
                continue  # 跳到下一次迭代
            fi
        fi
        
        if ln -s "$src" "$tgt" 2>/dev/null; then  # 尝试创建符号链接
            echo "✓ Created"  # 打印成功消息
        else  # 如果创建失败
            echo "✗ Error: Failed to create symlink"  # 打印错误消息
        fi
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then  # 检查脚本是否直接运行（而非被source）
    if [[ $# -ne 2 ]]; then  # 检查是否提供了恰好2个参数
        echo "Usage: $0 <source> <target>"  # 打印使用说明
        exit 1  # 以错误代码退出
    fi
    manage_links "$1" "$2"  # 使用命令行参数调用函数
fi