#!/bin/bash
# ============================================================================
# Script: gen_gpg.sh
# Description: Generate GPG key pair with RSA 4096-bit encryption
# Logic: Creates GPG configuration file, generates key pair, sets proper
#        permissions, and creates symbolic link if needed
# ============================================================================
# 脚本: gen_gpg.sh
# 描述: 生成 GPG 密钥对，使用 RSA 4096 位加密
# 逻辑: 创建 GPG 配置文件，生成密钥对，设置正确的权限，并在需要时创建符号链接
# ============================================================================

set -euo pipefail

gen_gpg() {
    # 1. def var
    local name=${1:-"kefu"}
    local email=${2:-"19157521820@163.com"}
    local pass=${3:-"lkf.Gpg.mima3"}
    local gen_to_dir=${4:-"/data/.home/.gnupg"}

    # 2. file already exist then exit
    [[ ! -d "$gen_to_dir" ]] || { echo "$gen_to_dir already exist";ln -sf "$gen_to_dir" "$HOME/.gnupg" ;return 0 ;}

    # 3.gen gpg
    local tmp="/tmp/gpg.conf"
    cat > "$tmp" <<EOF
%echo Generating a basic OpenPGP key
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $name
Name-Comment: Gpg
Name-Email: $email
Expire-Date: 0
Passphrase: $pass
%commit
%echo done
EOF

    gpg --batch --generate-key "$tmp"
    rm "$tmp"
#
    # 4. --> Set permissions --> 设置权限
    [[ "$gen_to_dir" == "$HOME/.gnupg" ]] || { mv -f $HOME/.gnupg $gen_to_dir ; ln -sf "$gen_to_dir" "$HOME/.gnupg" ; }

    local gd=$(realpath "$gen_to_dir")
    chmod 700 "$gd"
    chmod 600 "$gd"/* 2>/dev/null || true

    echo "✓ GPG key generated"
}

# --> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    gen_gpg "$@"
fi
