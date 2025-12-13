#!/bin/bash
# autorun.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$SCRIPT_DIR/config/autorun.yaml"

if ! command -v yq &> /dev/null; then
    echo "✗ 需要 yq"
    exit 1
fi

SCRIPT_COUNT=$(yq '.autorun | length' "$CONFIG")

for ((i=0; i<SCRIPT_COUNT; i++)); do
    script=$(yq -r ".autorun[$i]" "$CONFIG")
    
    # 如果是相对路径，加上 SCRIPT_DIR
    if [[ "$script" != /* ]]; then
        script_path="$SCRIPT_DIR/$script"
    else
        script_path="$script"
    fi
    
    echo "=== 运行: $script ==="
    
    if [ -f "$script_path" ]; then
        bash "$script_path" && echo "✓ 完成" || echo "✗ 失败"
    else
        echo "✗ 文件不存在: $script_path"
    fi
done
