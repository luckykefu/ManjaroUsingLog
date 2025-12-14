#!/bin/bash
set -e

git_auto_sync() {
    local repo_path="$1"
    local branch="${2:-main}"
    local message="${3:-auto run $(date +%Y/%m/%d-%H:%M:%S)}"
    local push="${4:-true}"
    
    # 检查参数
    if [ -z "$repo_path" ]; then
        echo "❌ Error: repo_path is required"
        return 1
    fi
    
    # 切换目录
    cd "$repo_path" || {
        echo "❌ Error: Cannot access $repo_path"
        return 1
    }
    
    # 检查是否为git仓库
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "❌ Error: Not a git repository"
        return 1
    fi
    
    # 切换分支
    git checkout "$branch" || {
        echo "❌ Error: Cannot checkout $branch"
        return 1
    }
    
    # 拉取最新代码（临时禁用set -e）
    set +e
    git pull origin "$branch" || echo "⚠️ Warning: Pull failed"
    set -e
    
    # 添加文件
    git add .
    
    # 提交和推送
    if ! git diff --cached --quiet; then
        git commit -m "$message"
        echo "✅ Committed: $message"
        if [ "$push" = "true" ]; then
            git push origin "$branch"
            echo "✅ Pushed to $branch"
        fi
    else
        echo "ℹ️ No changes to commit"
    fi
}

# 使用示例
# git_auto_sync "$(pwd)"
