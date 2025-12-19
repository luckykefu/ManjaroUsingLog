#!/bin/bash
# ============================================================================
# Script: install_themes.sh
# Description: Install WhiteSur KDE themes (icons, cursors, and desktop theme)
# Logic: Clones theme repositories from GitHub, runs install.sh scripts,
#        installs WhiteSur icon theme, KDE theme, and cursor theme
# ============================================================================
# 脚本: install_themes.sh
# 描述: 安装 WhiteSur KDE 主题（图标、光标和桌面主题）
# 逻辑: 从 GitHub 克隆主题仓库，运行 install.sh 脚本，
#        安装 WhiteSur 图标主题、KDE 主题和光标主题
# ============================================================================

set -euo pipefail

#--> Install theme from git repository --> 从 git 仓库安装主题
install_theme() {
    local git_url="$1"
    local themes_dir="${2:-$HOME/Downloads/.themes}"
    
    #--> Create themes directory --> 创建主题目录
    mkdir -p "$themes_dir"
    cd "$themes_dir" || return 1
    
    #--> Get theme name --> 获取主题名称
    local theme_name=$(basename "$git_url" .git)
    local theme_path="$themes_dir/$theme_name"
    
    #--> Clone and install if not exists --> 如果不存在则克隆并安装
    if [[ ! -d "$theme_path" ]]; then
        git clone "$git_url" &>/dev/null && echo "  ✓ Cloned $theme_name"
    fi
    
    if [[ -f "$theme_path/install.sh" ]]; then
        bash "$theme_path/install.sh" && echo "  ✓ Installed $theme_name"
    fi
}

#--> Install multiple themes --> 安装多个主题
install_themes() {
    local urls="https://github.com/vinceliuice/WhiteSur-icon-theme.git
https://github.com/vinceliuice/WhiteSur-kde.git
https://github.com/vinceliuice/WhiteSur-cursors.git"
    
    echo "🎨 Installing themes..."
    while IFS= read -r url; do
        url=$(echo "$url" | xargs)  # Trim whitespace
        [[ -z "$url" ]] && continue
        echo "Installing theme from: $url"
        install_theme "$url"
    done <<< "$urls"
    echo "✓ Themes installed"
}

#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_themes "$@"
fi

