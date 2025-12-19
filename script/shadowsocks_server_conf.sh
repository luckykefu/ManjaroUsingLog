#!/bin/bash
# ============================================================================
# Script: shadowsocks_server_conf.sh
# Description: Deploy and configure Shadowsocks server with firewall rules
# Logic: Installs shadowsocks, creates config with encryption method and port,
#        enables systemd service, configures iptables firewall rules,
#        displays connection information and status
# ============================================================================
# 脚本: shadowsocks_server_conf.sh
# 描述: 部署和配置带防火墙规则的 Shadowsocks 服务器
# 逻辑: 安装 shadowsocks，创建包含加密方法和端口的配置，启用 systemd 服务，
#        配置 iptables 防火墙规则，显示连接信息和状态
# ============================================================================

set -euo pipefail

#--> Setup Shadowsocks server --> 设置 Shadowsocks 服务器
shadowsocks_server_conf() {
    local password=${1:-}
    local port="${2:-8388}"
    local method="${3:-aes-256-gcm}"
    local config_name="${4:-config}"
    
    #--> Check required parameters --> 检查必需参数
    if [[ -z "$password" ]]; then
        echo "❌ Error: Password is required"
        echo "Usage: $0 <password> [port] [method] [config_name]"
        return 0
    fi
    
    #--> Install Shadowsocks --> 安装 Shadowsocks
    echo "🔧 Installing Shadowsocks..."
    sudo pacman -S shadowsocks --noconfirm --needed
    
    #--> Create config --> 创建配置
    echo "📝 Creating config file..."
    sudo mkdir -p /etc/shadowsocks
    
    sudo tee "/etc/shadowsocks/${config_name}.json" > /dev/null <<EOF
{
    "server": "0.0.0.0",
    "server_port": $port,
    "password": "$password",
    "method": "$method",
    "timeout": 300,
    "fast_open": false,
    "mode": "tcp_and_udp"
}
EOF
    
    #--> Enable and start service --> 启用并启动服务
    echo "🚀 Starting service..."
    sudo systemctl enable --now "shadowsocks-server@${config_name}"
    
    #--> Configure firewall --> 配置防火墙
    echo "🔥 Configuring firewall..."
    sudo iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
    sudo iptables -A INPUT -p udp --dport "$port" -j ACCEPT
    sudo mkdir -p /etc/iptables
    sudo iptables-save | sudo tee /etc/iptables/iptables.rules > /dev/null
    
    #--> Show status --> 显示状态
    echo "✅ Deployment complete!"
    echo "📊 Service status:"
    sudo systemctl status "shadowsocks-server@${config_name}" --no-pager
    
    echo ""
    echo "📋 Configuration:"
    sudo cat "/etc/shadowsocks/${config_name}.json"
    
    echo ""
    echo "🔗 Connection info:"
    echo "  Server: $(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_SERVER_IP')"
    echo "  Port: $port"
    echo "  Password: $password"
    echo "  Method: $method"
}

#--> Show help --> 显示帮助
show_help() {
    cat <<EOF
Shadowsocks Server Configuration Tool

Usage:
  $0 <password> [port] [method] [config_name]

Parameters:
  password    Required, connection password
  port        Optional, default 8388
  method      Optional, default aes-256-gcm
  config_name Optional, default config

Examples:
  $0 mypassword123
  $0 mypassword123 9999
  $0 mypassword123 9999 chacha20-ietf-poly1305
  $0 mypassword123 9999 aes-256-gcm myserver

Common methods:
  - aes-256-gcm (recommended)
  - chacha20-ietf-poly1305 (recommended)
  - aes-128-gcm
EOF
}

#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-help}" in
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            shadowsocks_server_conf "$@"
            ;;
    esac
fi
