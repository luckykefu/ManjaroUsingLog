#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import logging
from pathlib import Path

# 设置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def add_path_to_zshrc(target):
    """
    添加语句到 ~/.zshrc 文件中

    参数:
        target (str): 要添加到 ~/.zshrc 的完整语句

    返回:
        bool: 操作是否成功
    """
    try:
        # 获取用户主目录
        home_dir = Path.home()
        zshrc_path = home_dir / ".zshrc"

        # 检查 ~/.zshrc 文件是否存在，如果不存在则创建
        if not zshrc_path.exists():
            logger.warning(f"{zshrc_path} 不存在，将创建新文件")
            zshrc_path.touch()

        # 读取 ~/.zshrc 文件内容
        with open(zshrc_path, 'r') as f:
            content = f.read()

        # 检查目标语句是否已存在于文件中
        if target in content:
            logger.info(f"语句 '{target}' 已存在于 ~/.zshrc 中，跳过添加")
            return True

        # 添加新的语句到文件末尾
        with open(zshrc_path, 'a') as f:
            f.write(f'\n{target}\n')

        logger.info(f"成功将语句 '{target}' 添加到 ~/.zshrc")
        return True

    except Exception as e:
        logger.error(f"添加语句到 ~/.zshrc 时出错: {str(e)}")
        return False

def test_add_path():
    """
    测试 add_path_to_zshrc 函数
    """
    # 创建临时测试语句
    test_statement = 'export PATH="$PATH:/test/path"' 

    # 备份原始 ~/.zshrc
    home_dir = Path.home()
    zshrc_path = home_dir / ".zshrc"
    backup_path = home_dir / ".zshrc.backup"

    try:
        # 如果 ~/.zshrc 存在，则创建备份
        if zshrc_path.exists():
            with open(zshrc_path, 'r') as src, open(backup_path, 'w') as dst:
                dst.write(src.read())

        # 测试添加语句
        print("测试 1: 添加新语句")
        result = add_path_to_zshrc(test_statement)
        print(f"结果: {'成功' if result else '失败'}")

        # 验证是否添加成功
        with open(zshrc_path, 'r') as f:
            content = f.read()
        if test_statement in content:
            print("验证: 语句已成功添加")
        else:
            print("验证: 语句添加失败")

        # 测试重复添加
        print("\n测试 2: 重复添加相同语句")
        result = add_path_to_zshrc(test_statement)
        print(f"结果: {'成功' if result else '失败'}")

        # 恢复原始 ~/.zshrc
        if backup_path.exists():
            with open(backup_path, 'r') as src, open(zshrc_path, 'w') as dst:
                dst.write(src.read())
            backup_path.unlink()

    except Exception as e:
        print(f"测试过程中出错: {str(e)}")

        # 尝试恢复备份
        if backup_path.exists():
            with open(backup_path, 'r') as src, open(zshrc_path, 'w') as dst:
                dst.write(src.read())
            backup_path.unlink()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        # 从命令行参数获取目标语句
        target = sys.argv[1]
        add_path_to_zshrc(target)
    else:
        # 如果没有提供参数，则运行测试
        print("未提供语句参数，运行测试...")
        test_add_path()
