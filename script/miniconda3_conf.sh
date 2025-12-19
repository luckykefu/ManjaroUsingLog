#!/bin/bash
# ============================================================================
# Script: install_miniconda3.sh
# Description: Download and install latest Miniconda3 distribution
# Logic: Downloads Miniconda installer with aria2c, removes old installation,
#        installs to specified directory, initializes conda for zsh,
#        enables auto-activation, installs jupyter and ipykernel
# ============================================================================
# 脚本: install_miniconda3.sh
# 描述: 下载并安装最新的 Miniconda3 发行版
# 逻辑: 使用 aria2c 下载 Miniconda 安装程序，删除旧安装，安装到指定目录，
#        为 zsh 初始化 conda，启用自动激活，安装 jupyter 和 ipykernel
# ============================================================================

set -euo pipefail

#--> Install Miniconda3 --> 安装 Miniconda3
miniconda3_conf() {
    local install_dir="${1:-/data/.miniconda3}"
    rm -rf "$install_dir"
    local download_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    local save_path="$HOME/Downloads"
    local installer="Miniconda3-latest-Linux-x86_64.sh"
    
    #--> Prepare directories --> 准备目录
    mkdir -p "$save_path"
    cd "$save_path"
    
    #--> Download with aria2c --> 使用 aria2c 下载
    [[ -f "$installer" ]] || aria2c -c -x 16 -s 16 "$download_url" -d "$save_path"
    
    #--> Remove old installation --> 删除旧安装
    rm -rf "$install_dir"
    mkdir -p "$(dirname "$install_dir")"
    
    #--> Install --> 安装
    bash "$installer" -b -f -p "$install_dir"
    
    #--> Verify and configure --> 验证并配置
    if [[ -f "$install_dir/bin/conda" ]]; then
        echo "✓ Miniconda3 installed successfully"
        "$install_dir/bin/conda" init zsh
        "$install_dir/bin/conda" config --set auto_activate_base false
        "$install_dir/bin/conda" install jupyter ipykernel -y
        echo "✓ Miniconda3 configured! Run: source ~/.zshrc"
    else
        echo "❌ Miniconda3 installation failed"
        return 1
    fi
}

#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    miniconda3_conf "$@"
fi
