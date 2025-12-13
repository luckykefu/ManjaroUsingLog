#!/bin/bash
# autogit.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG=${1:-$SCRIPT_DIR/config/autogit.yaml}

if [ ! -f "$CONFIG" ]; then
    echo "✗ 配置文件不存在: $CONFIG"
    exit 1
fi

if ! command -v yq &> /dev/null; then
    echo "✗ 需要安装 yq: sudo pacman -S yq"
    exit 1
fi

COMMIT_MSG=$(yq -r '.commit_msg' "$CONFIG")
REPO_COUNT=$(yq '.repos | length' "$CONFIG")

for ((i=0; i<REPO_COUNT; i++)); do
    repo=$(yq -r ".repos[$i].path" "$CONFIG")
    branch=$(yq -r ".repos[$i].branch" "$CONFIG")
    
    [ -z "$repo" ] && continue
    
    echo "=== $repo [$branch] ==="
    
    [ ! -d "$repo" ] && { echo "✗ 不存在"; continue; }
    
    cd "$repo" || continue
    
    [ -z "$(git status --porcelain)" ] && { echo "无变更"; continue; }
    
    git add -A
    git commit --no-gpg-sign -m "$COMMIT_MSG: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null || true
    git push origin "$branch" && echo "✓ 完成" || echo "✗ 失败"
done
