## 查找 KDE Plasma 配置文件plasma-org.kde.plasma.desktop-appletsrc 中第一个 TARGET_PLUGIN 对应的 [Containments][xxx] ID

import re
import os
# 目标插件标识符
def find_containments_id(target_plugin: str, text: str = None):
    """
    在 KDE Plasma 配置文件或提供的文本中查找 target_plugin
    所对应的 [Containments][xxx] ID。target_plugin 可以是多行文本。

    参数:
        target_plugin (str): 要查找的插件字符串，可以包含多行。
        text (str, optional): 多行文本，如果提供则在文本中查找，否则在配置文件中查找。

    返回:
        list: 匹配的纯数字 ID 列表，如果未找到则返回空列表。
    """
    # 正则表达式：匹配 [Containments][xxx] 并捕获 xxx
    HEADER_PATTERN = re.compile(r'^\[Containments\]\[(\d+)\]')

    if text is not None:
        content = text
    else:
        config_path = os.path.expanduser("~/.config/plasma-org.kde.plasma.desktop-appletsrc")
        try:
            with open(config_path, 'r') as f:
                content = f.read()
        except FileNotFoundError:
            print(f"错误：配置文件未找到于 {config_path}")
            return None

    # 查找 target_plugin 在 content 中的位置
    target_pos = content.find(target_plugin.strip())
    if target_pos == -1:
        return None


    # 向前查找最近的 [Containments][xxx]
    before = content[:target_pos]
    lines_before = before.split('\n')
    for line in reversed(lines_before):
        header_match = HEADER_PATTERN.match(line.strip())
        if header_match:
            return header_match.group(1)

    return None

def main():
    import argparse
    import sys
    parser = argparse.ArgumentParser(description='Find Containments ID')
    parser.add_argument('target', nargs='?', type=str, help='The target to search for (multi-line from stdin if not provided)')
    parser.add_argument('--text', type=str, help='Multi-line text to search in (optional)')
    args = parser.parse_args()

    if args.target is None:
        # 从 stdin 读取多行 target_plugin
        target_plugin = sys.stdin.read().strip()
    else:
        target_plugin = args.target

    if args.text:
        target_ids = find_containments_id(target_plugin, args.text)
    else:
        target_ids = find_containments_id(target_plugin)

    if target_ids:
        print(target_ids)
    else:
        print("未找到匹配的 ID")
    return target_ids

if __name__ == "__main__":
    main()
