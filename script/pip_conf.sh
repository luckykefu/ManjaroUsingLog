#!/bin/bash
# ============================================================================
# Script: pip_conf.sh
# Description: Configure pip to use Tsinghua University mirror for faster downloads
# Logic: Creates pip config directory and writes configuration file with
#        Tsinghua mirror URL, trusted host, and timeout settings
# ============================================================================
# 脚本: pip_conf.sh
# 描述: 配置 pip 使用清华大学镜像以加快下载速度
# 逻辑: 创建 pip 配置目录并写入配置文件，包含清华镜像 URL、可信任主机和超时设置
# ============================================================================

set -euo pipefail

#--> Configure pip --> 配置 pip
pip_conf() {
    # 1. if exist.return
    local src="/data/.home/.config/pip"
    mkdir -p $src
    cat > "$src/pip.conf" <<'EOF'
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn
timeout = 120
[install]
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF

    local tgt="$HOME/.config/pip"
    rm -rf "$tgt"
    ln -sf "$src" "$tgt"
    echo "✓ pip config created"
}

#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    pip_conf "$@"
fi
