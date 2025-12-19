#!/bin/bash
# ============================================================================
# Script: yay_conf.sh
# Description: Configure yay AUR helper with optimized settings
# Logic: Creates yay config.json with build directory, concurrent downloads,
#        batch install, and cleanup settings for efficient AUR package management
# ============================================================================
# 脚本: yay_conf.sh
# 描述: 配置 yay AUR 助手的优化设置
# 逻辑: 创建 yay config.json，包含构建目录、并发下载、批量安装和清理设置，
#        用于高效的 AUR 包管理
# ============================================================================

set -euo pipefail

#--> Configure yay --> 配置 yay
yay_conf() {
    local srs="/data/.home/.config/yay"
    cat > "$srs/config.json" <<'EOF'

{
    "buildDir": "/tmp/yay",
    "editor": "nano",
    "pacmanbin": "pacman",
    "pacmanconf": "/etc/pacman.conf",
    "answerclean": "All",
    "removemake": "ask",
    "maxconcurrentdownloads": 16,
    "cleanAfter": false,
    "batchinstall": true,
    "DevelCheckUpdate": false
}
EOF
    local tgt="$HOME/.config/yay"
    rm -fr "$tgt"
    ln -sf "$srs" "$tgt"
    echo "✓ Yay config created"
}

#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    yay_conf "$@"
fi
