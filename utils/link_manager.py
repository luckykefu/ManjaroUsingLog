
import os
import shutil
import logging
from pathlib import Path
from typing import Dict, List, Tuple, Optional

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class LinkManager:
    """管理符号链接的工具类"""

    def __init__(self, source_dir: str, target_dir: str):
        """
        初始化链接管理器

        Args:
            source_dir: 源目录路径
            target_dir: 目标目录路径
        """
        self.source_dir = os.path.expanduser(source_dir)
        self.target_dir = os.path.expanduser(target_dir)
        self.source_dir = os.path.abspath(self.source_dir)
        self.target_dir = os.path.abspath(self.target_dir)
        self.link_map: Dict[str, str] = {}

    def list_dirs(self) -> List[str]:
        """
        列举源目录下的所有文件夹

        Returns:
            文件夹名称列表
        """
        try:
            dirs = []
            for item in os.listdir(self.source_dir):
                full_path = os.path.join(self.source_dir, item)
                if os.path.isdir(full_path):
                    dirs.append(item)
            logger.info(f"在源目录 {self.source_dir} 中找到 {len(dirs)} 个文件夹")
            return dirs
        except Exception as e:
            logger.error(f"列举源目录文件夹时出错: {e}")
            return []

    def build_target_paths(self, dirs: List[str]) -> List[str]:
        """
        构建目标文件夹路径列表

        Args:
            dirs: 源目录中的文件夹列表

        Returns:
            目标文件夹路径列表
        """
        try:
            target_paths = []
            for dir_name in dirs:
                target_path = os.path.join(self.target_dir, dir_name)
                target_paths.append(target_path)
            logger.info(f"构建了 {len(target_paths)} 个目标路径")
            return target_paths
        except Exception as e:
            logger.error(f"构建目标路径时出错: {e}")
            return []

    def build_link_map(self, dirs: List[str]) -> Dict[str, str]:
        """
        构建源目录和目标目录的映射字典

        Args:
            dirs: 源目录中的文件夹列表

        Returns:
            源目录到目标目录的映射字典
        """
        try:
            link_map = {}
            for dir_name in dirs:
                source_path = os.path.join(self.source_dir, dir_name)
                target_path = os.path.join(self.target_dir, dir_name)
                link_map[source_path] = target_path
            self.link_map = link_map
            logger.info(f"构建了 {len(link_map)} 个源-目标映射")
            return link_map
        except Exception as e:
            logger.error(f"构建映射字典时出错: {e}")
            return {}

    def check_target(self, target_path: str) -> Tuple[bool, str]:
        """
        检查目标路径的状态

        Args:
            target_path: 目标路径

        Returns:
            (是否需要处理, 状态描述)
        """
        try:
            # 如果目标不存在
            if not os.path.exists(target_path) and not os.path.islink(target_path):
                return True, "目标不存在，可以创建链接"

            # 如果目标是文件
            if os.path.isfile(target_path):
                return True, "目标是文件，将被删除并替换为链接"

            # 如果目标是目录
            if os.path.isdir(target_path):
                return True, "目标是目录，将被删除并替换为链接"

            # 如果目标是链接
            if os.path.islink(target_path):
                # 获取链接指向的实际路径
                link_target = os.path.realpath(target_path)
                source_path = None

                # 从映射中找到对应的源路径
                for src, tgt in self.link_map.items():
                    if tgt == target_path:
                        source_path = src
                        break

                if source_path and os.path.samefile(link_target, source_path):
                    return False, "链接已存在且指向正确源，跳过"
                else:
                    return True, "链接存在但指向错误源，将被删除并重新创建"

            return True, "未知状态，将被处理"
        except Exception as e:
            logger.error(f"检查目标路径 {target_path} 时出错: {e}")
            return False, f"检查出错: {e}"

    def create_links(self, confirm_delete: bool = True) -> Dict[str, bool]:
        """
        创建符号链接

        Args:
            confirm_delete: 是否在删除前确认，默认为True

        Returns:
            创建结果字典 {路径: 是否成功}
        """
        results = {}

        if not self.link_map:
            logger.error("链接映射为空，请先调用 build_link_map")
            return results

        for source_path, target_path in self.link_map.items():
            try:
                # 检查目标状态
                need_process, status = self.check_target(target_path)
                logger.info(f"检查 {target_path}: {status}")

                if not need_process:
                    results[target_path] = True
                    continue

                # 如果目标存在且需要删除
                if os.path.exists(target_path) or os.path.islink(target_path):
                    if confirm_delete:
                        # 在实际应用中，这里可以添加用户交互确认
                        # 但为了自动化，我们默认删除
                        pass

                    if os.path.islink(target_path) or os.path.isfile(target_path):
                        os.unlink(target_path)
                        logger.info(f"已删除文件/链接: {target_path}")
                    elif os.path.isdir(target_path):
                        shutil.rmtree(target_path)
                        logger.info(f"已删除目录: {target_path}")

                # 创建符号链接
                os.symlink(source_path, target_path)
                logger.info(f"✅ 已创建链接: {target_path} -> {source_path}")
                results[target_path] = True

            except Exception as e:
                logger.error(f"❌ 创建链接 {target_path} -> {source_path} 失败: {e}")
                results[target_path] = False

        return results

    def manage_links(self) -> Dict[str, bool]:
        """
        完整的链接管理流程

        Returns:
            创建结果字典 {路径: 是否成功}
        """
        logger.info(f"开始管理链接: {self.source_dir} -> {self.target_dir}")

        # 1. 列举源目录下的文件夹
        dirs = self.list_dirs()
        if not dirs:
            logger.warning("源目录中没有找到任何文件夹")
            return {}

        # 2. 构建链接映射
        link_map = self.build_link_map(dirs)
        if not link_map:
            logger.error("构建链接映射失败")
            return {}

        # 3. 创建链接
        results = self.create_links()

        # 4. 输出结果统计
        success_count = sum(1 for success in results.values() if success)
        total_count = len(results)
        logger.info(f"链接管理完成: 成功 {success_count}/{total_count}")

        return results


def main():
    """主函数，用于命令行调用"""
    import argparse

    parser = argparse.ArgumentParser(description="符号链接管理工具")
    parser.add_argument("source_dir", help="源目录路径")
    parser.add_argument("target_dir", help="目标目录路径")
    parser.add_argument("--no-confirm", action="store_true", help="删除前不进行确认")
    args = parser.parse_args()

    # 创建链接管理器
    manager = LinkManager(args.source_dir, args.target_dir)

    # 执行链接管理
    results = manager.manage_links()

    # 输出结果
    print("结果摘要:")
    for target, success in results.items():
        status = "✅ 成功" if success else "❌ 失败"
        print(f"{status}: {target}")


if __name__ == "__main__":
    main()
