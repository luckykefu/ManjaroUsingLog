#!/bin/bash
# ============================================================================
# Script: proxy_conf.sh
# Description: Configure and start mihomo proxy with clash configuration
# Logic: Downloads GeoIP database if needed, starts mihomo daemon with config,
#        extracts and displays proxy port settings (HTTP, SOCKS, MIXED)
# ============================================================================
# 脚本: proxy_conf.sh
# 描述: 配置并启动 mihomo 代理和 clash 配置
# 逻辑: 如需下载 GeoIP 数据库，使用配置启动 mihomo 守护进程，
#        提取并显示代理端口设置（HTTP、SOCKS、MIXED）
# ============================================================================

set -euo pipefail

#--> Configure proxy with mihomo --> 配置 mihomo 代理
proxy_conf() {
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local clash_cf=${1:-"$SCRIPT_DIR/../config/clash.yaml"}
    local geoip_f=${2:-"$SCRIPT_DIR/../config/geoip.metadb"}

    
    if [ -f "$clash_cf" ]; then
        mkdir -p "$HOME/.config/mihomo"
        if [[ ! -f "$geoip_f" ]]; then
            wget -O "$HOME/.config/mihomo/geoip.metadb" https://github.com/MetaCubeX/meta-rules-dat/releases/latest/download/geoip.metadb || { echo "Failed to download GeoIP"; return 1; }
        else
            cp "$geoip_f" "$HOME/.config/mihomo/geoip.metadb"
        fi

        #--> Start mihomo --> 启动 mihomo
        pkill -f mihomo 2>/dev/null || true
        nohup mihomo -f "$clash_cf" > "$HOME/.config/mihomo/mihomo.log" 2>&1 &
        
        #--> Get proxy settings from config --> 从配置获取代理设置
        local http_port=$(grep -E "^port:" "$clash_cf" | awk '{print $2}')
        local socks_port=$(grep -E "^socks-port:" "$clash_cf" | awk '{print $2}')
        local mixed_port=$(grep -E "^mixed-port:" "$clash_cf" | awk '{print $2}')
        echo "✓ Mihomo started"
        [[ -n "$http_port" ]] && echo "   HTTP:  127.0.0.1:$http_port"
        [[ -n "$socks_port" ]] && echo "   SOCKS: 127.0.0.1:$socks_port"
        [[ -n "$mixed_port" ]] && echo "   MIXED: 127.0.0.1:$mixed_port"
    fi
}

#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    proxy_conf "$@"
fi
