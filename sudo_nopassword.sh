#!/bin/bash
# ============================================================================
# Script: sudo_nopassword.sh
# Description: Configure sudo to work without password for current user
# Logic: Creates sudoers file in /etc/sudoers.d/, validates syntax with visudo,
#        sets proper permissions (440), ensures safe configuration
# ============================================================================
# 脚本: sudo_nopassword.sh
# 描述: 配置当前用户的 sudo 免密码功能
# 逻辑: 在 /etc/sudoers.d/ 中创建 sudoers 文件，使用 visudo 验证语法，
#        设置正确的权限（440），确保安全配置
# ============================================================================

set -euo pipefail

#--> Configure sudo without password --> 配置 sudo 免密码
sudo_nopassword() {
    # 1. get user
    local U="$USER"
    [[ -n "$U" ]] && echo "current user : $U" || return 1

    # 2.def configuration file
    local SF=/etc/sudoers.d/${U}_sudo_nopassword
    echo "configuration file : $SF"

    # 3.configur it
    echo "$U ALL=(ALL) NOPASSWD: ALL" | sudo tee "$SF" || { echo "❌ Failed to create $SF"; return 1; }

    # 4.#--> Validate syntax --> 验证语法
    sudo visudo -c -f "$SF"  || {
        echo "❌ Invalid sudoers syntax"
        sudo rm -f "$SF"
        return 1
}

    # 5.#--> Set permissions --> 设置权限
    sudo chmod 440 "$SF" && echo "✓ Permissions set (440)" ||{
        echo "❌ Failed to set permissions"
        sudo rm -f "$SF"
        return 1
}

    # 6.echo OK
    echo "✓ Sudo no password configured for $U"
}

install_jupyter(){
    sudo pacman -S --needed --noconfirm python-pip python-ipykernel jupyter-notebook
    local f=$HOME/.jupyter/jupyter_notebook_config.py
    [[ -f "$f" ]] || jupyter notebook --generate-config
    local l="c.ContentsManager.line_numbers = True"
    grep "$l" $f || echo "$l" >> $f


}
#--> Run if executed directly --> 如果直接执行则运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    sudo_nopassword
    install_jupyter
fi
