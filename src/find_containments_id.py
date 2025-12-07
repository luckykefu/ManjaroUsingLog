## 查找 KDE Plasma 配置文件plasma-org.kde.plasma.desktop-appletsrc 中第一个 TARGET_PLUGIN 对应的 [Containments][xxx] ID

import re
import os
# 目标插件标识符
def find_containments_id(TARGET_PLUGIN):
    """
    在 KDE Plasma 配置文件中查找第一个 plugin=org.kde.plasma.folder 
    所对应的 [Containments][xxx] ID。

    返回: 
        str 或 None: 容器的纯数字 ID，如果未找到则返回 None。
    """
    # 配置文件路径，基于用户目录
    config_path = os.path.expanduser("~/.config/plasma-org.kde.plasma.desktop-appletsrc")

    # 正则表达式：匹配 [Containments][xxx] 并捕获 xxx
    # r'^\[Containments\]\[(\d+)\]'
    HEADER_PATTERN = re.compile(r'^\[Containments\]\[(\d+)\]')



    current_id = None

    try:
        with open(config_path, 'r') as f:
            for line in f:
                line = line.strip()

                # 1. 匹配区块标题并提取 ID (对应 awk 的 /^\[Containments\]\[[0-9]+\]/ 块)
                header_match = HEADER_PATTERN.match(line)
                if header_match:
                    # 存储 ID (对应 awk 的 current_id = $3)
                    current_id = header_match.group(1) 

                # 2. 匹配目标插件行
                elif line == TARGET_PLUGIN and current_id is not None:
                    # 打印 ID 并返回 (对应 awk 的 print current_id; exit;)
                    return current_id 

        # 如果循环结束仍未找到，返回 None
        return None 

    except FileNotFoundError:
        print(f"错误：配置文件未找到于 {config_path}")
        return None
if __name__ == "__main__":
    TARGET_PLUGIN = 'plugin=org.kde.plasma.folder'
    target_id = find_containments_id(TARGET_PLUGIN)

    if target_id:
        print(f"{target_id}")
    else:
        print(f"未找到匹配的插件：{TARGET_PLUGIN}")
