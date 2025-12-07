#!/bin/bash
# ──────────────────────────────────────────────────────────────
# 安全地把一行内容追加到 ~/.zshrc（自动防重复）
# 用法示例（在 Jupyter 里直接跑这个 cell 就行）：
#   source src/bash_add_path2zshrc.sh "export PATH=\"/home/you/bin:$PATH\""
#   source src/bash_add_path2zshrc.sh "alias resolve='LD_PRELOAD=... /opt/resolve/bin/resolve'"
# ──────────────────────────────────────────────────────────────

set -euo pipefail

ZSHRC="$HOME/.zshrc"
CONTENT="$1"

# 方法1：完全精确匹配整行（最严格）
if ! grep -Fxq "$CONTENT" "$ZSHRC" 2>/dev/null; then
    echo "$CONTENT" >> "$ZSHRC"
    echo "已追加到 $ZSHRC"
    echo "   $CONTENT"
else
    echo "已存在，跳过重复追加"
    echo "   $CONTENT"
fi

# 方法2：如果你只想防关键字重复（更宽松，适合 PATH 这种多段的情况）
# 取消下面注释即可替换上面的判断
# if ! grep -q "$(echo "$CONTENT" | sed 's|/|\\/|g')" "$ZSHRC" 2>/dev/null; then
#     echo "$CONTENT" >> "$ZSHRC"
#     echo "已追加：$CONTENT"
# else
#     echo "已存在类似配置，跳过"
# fi

# 最后提醒重新加载
echo "请执行下面任意一条让配置立刻生效："
echo "   source ~/.zshrc"
echo "   或者直接重启终端"
