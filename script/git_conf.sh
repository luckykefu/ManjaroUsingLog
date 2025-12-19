#!/bin/bash
# ============================================================================
# Script: git_conf.sh
# Description: Configure global Git settings including user info and GPG signing
# Logic: Retrieves GPG signing key from system, configures Git with user name,
#        email, default branch, GPG program, signing key, and credential helper
# ============================================================================
# 脚本: git_conf.sh
# 描述: 配置全局 Git 设置，包括用户信息和 GPG 签名
# 逻辑: 从系统获取 GPG 签名密钥，配置 Git 用户名、邮箱、默认分支、GPG 程序、
#        签名密钥和凭据助手
# ============================================================================

set -euo pipefail

#--> Configure git --> 配置 git
git_conf() {
    local name=${1:-"kefu"}
    local email=${2:-"19157521820@163.com"}

    #--> Get GPG signing key --> 获取 GPG 签名密钥
    local signingkey=$(gpg --list-secret-keys --keyid-format SHORT 2>/dev/null | grep sec | awk '{print $2}' | cut -d'/' -f2 | head -1)

    #--> Configure git settings --> 配置 git 设置
    declare -A git_settings=(
        ["user.name"]="kefu"
        ["user.email"]="19157521820@163.com"
        ["init.defaultBranch"]="main"
        ["gpg.program"]="gpg"
        ["user.signingkey"]="$signingkey"
        ["commit.gpgsign"]="false"
        ["credential.helper"]="store"
    )

    for key in "${!git_settings[@]}"; do
        git config --global "$key" "${git_settings[$key]}"
    done
    
    echo "✓ Git configured"
}

#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    git_conf "$@"
fi
