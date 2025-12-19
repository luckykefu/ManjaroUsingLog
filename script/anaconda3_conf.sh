#!/bin/bash
# ============================================================================
# Script: install_anaconda3.sh
# Description: Download and install latest Anaconda3 distribution
# Logic: Fetches latest version from Anaconda repository, downloads with aria2c,
#        installs to specified directory, initializes conda for zsh,
#        disables auto-activation, installs jupyter and ipykernel
# ============================================================================
# 脚本: install_anaconda3.sh
# 描述: 下载并安装最新的 Anaconda3 发行版
# 逻辑: 从 Anaconda 仓库获取最新版本，使用 aria2c 下载，安装到指定目录，
#        为 zsh 初始化 conda，禁用自动激活，安装 jupyter 和 ipykernel
# ============================================================================

set -euo pipefail

#--> Install Anaconda3 --> 安装 Anaconda3
anaconda3_conf() {
    local install_dir="${1:-/data/.anaconda3}"
    rm -rf "$install_dir"
    local save_path="$HOME/Downloads"
    
    #--> Prepare directories --> 准备目录
    rm -rf "$install_dir"
    mkdir -p "$(dirname "$install_dir")" "$save_path"
    cd "$save_path"
    
    #--> Get latest Anaconda version --> 获取最新 Anaconda 版本
    local base_url="https://repo.anaconda.com/archive/"
    local latest_version=$(wget -q -O - "$base_url" | grep -o '"Anaconda3-[0-9.]*-[0-9]*-Linux-x86_64.sh"' | sort -V | tail -1 | tr -d '"')
    local download_url="$base_url/$latest_version"
    
    [[ -z "$latest_version" ]] && echo "❌ Failed to get latest version" && return 1
    
    #--> Download with aria2c --> 使用 aria2c 下载
    [[ -f "$latest_version" ]] || aria2c -c -x 16 -s 16 "$download_url" -d "$save_path"
    
    #--> Install --> 安装
    bash "$latest_version" -b -p "$install_dir"
    [[ ! -f "$install_dir/bin/conda" ]] && echo "❌ Anaconda3 installation failed" && return 1
    
    #--> Initialize --> 初始化
    "$install_dir/bin/conda" init zsh
    "$install_dir/bin/conda" config --set auto_activate_base false
    "$install_dir/bin/conda" install jupyter notebook jupyter_contrib_nbextensions ipykernel  jupyter_nbextensions_configurator -y
    
    echo "✓ Anaconda3 installed! Run: source ~/.zshrc"
}

#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    anaconda3_conf "$@"
fi
