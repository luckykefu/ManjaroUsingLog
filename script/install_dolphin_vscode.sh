#!/bin/bash
install_dolphin_vscode() {
    local dest_dir="$HOME/.local/share/kio/servicemenus"
    local temp_dir="/tmp/dolphin-vscode-$$"
    
    mkdir -p "$dest_dir"
    if git clone git@github.com:Merrit/kde-dolphin-open-vscode.git "$temp_dir" &>/dev/null; then
        mv "$temp_dir/openVSCode.desktop" "$dest_dir/openVSCode.desktop"
        chmod +x "$dest_dir/openVSCode.desktop"
        rm -rf "$temp_dir"
        echo "  ✓ Dolphin VSCode menu installed"
    else
        echo "  ✗ Failed to install Dolphin VSCode menu"
    fi
}
