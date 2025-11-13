# add path to shrc
import os
import glob

def add_path_to_shrc(path_need_add, config_file_path=os.path.expanduser("~/.zshrc")):
    """
    向shell配置文件（默认为~/.zshrc）中添加路径到PATH环境变量
    
    Args:
        path_need_add (str): 需要添加到PATH的路径
        config_file_path (str, optional): 自定义配置文件路径，默认为None（使用~/.zshrc）
    
    Returns:
        bool: 如果路径已存在返回False，成功添加返回True
    
    Example:
        >>> add_path_to_shrc("/usr/local/bin")
        # 会在~/.zshrc文件中添加一行：export PATH=/usr/local/bin:$PATH
    """
    try:
        # 标准化路径（处理 ~, 相对路径等）
        path_need_add = os.path.expanduser(path_need_add)
        path_need_add = os.path.abspath(path_need_add)
        
        # 检查路径是否存在
        if not os.path.exists(path_need_add):
            create_dir = input(f"路径 {path_need_add} 不存在，是否创建？(y/N): ").strip().lower()
            if create_dir in ['y', 'yes']:
                os.makedirs(path_need_add, exist_ok=True)
                print(f"已创建目录: {path_need_add}")
            else:
                print(f"路径 {path_need_add} 不存在，跳过添加")
                return False
        
        # 检查配置文件是否存在，如果不存在则创建
        os.makedirs(os.path.dirname(config_file_path), exist_ok=True)
        if not os.path.exists(config_file_path):
            with open(config_file_path, "w") as f:
                f.write("# Shell configuration file\n")
        
        # 检查路径是否已经存在
        with open(config_file_path, "r") as f:
            content = f.read()
        
        # 检查是否已经存在相同的路径导出语句（支持多种格式）
        export_patterns = [
            f'export PATH="{path_need_add}:$PATH"',
            f'export PATH="$PATH:{path_need_add}"',
            f"export PATH='{path_need_add}:$PATH'",
            f"export PATH='$PATH:{path_need_add}'"
        ]
        
        for pattern in export_patterns:
            if pattern in content:
                print(f"路径: {path_need_add} 已经存在于配置文件: {config_file_path} 中")
                return False
        
        # 以追加模式打开配置文件，添加PATH导出语句
        with open(config_file_path, "a") as f:
            f.write(f'\nexport PATH="{path_need_add}:$PATH"\n')
        
        print(f"✅ 成功添加路径: {path_need_add} 到配置文件 {config_file_path}")
        print(f"💡 请运行 'source {config_file_path}' 使配置生效")
        return True
        
    except Exception as e:
        print(f"❌ 添加路径时出错: {e}")
        return False


def remove_path_from_shrc(path_to_remove, config_file_path=os.path.expanduser("~/.zshrc")):
    """
    从shell配置文件中移除指定的路径
    
    Args:
        path_to_remove (str): 需要从PATH中移除的路径
        config_file_path (str, optional): 自定义配置文件路径，默认为None（使用~/.zshrc）
    
    Returns:
        bool: 如果路径不存在返回False，成功移除返回True
    """
    try:
        if not os.path.exists(config_file_path):
            print(f"❌ 配置文件: {config_file_path} 不存在")
            return False
        
        # 标准化路径
        path_to_remove = os.path.expanduser(path_to_remove)
        path_to_remove = os.path.abspath(path_to_remove)
        
        # 读取文件内容
        with open(config_file_path, "r") as f:
            lines = f.readlines()
        
        # 查找并移除包含指定路径的行（支持多种格式）
        original_length = len(lines)
        new_lines = []
        removed = False
        
        for line in lines:
            if any(pattern in line for pattern in [
                f'export PATH="{path_to_remove}:$PATH"',
                f'export PATH="$PATH:{path_to_remove}"',
                f"export PATH='{path_to_remove}:$PATH'",
                f"export PATH='$PATH:{path_to_remove}'"
            ]):
                removed = True
                continue
            new_lines.append(line)
        
        # 如果内容有变化，则写回文件
        if removed:
            with open(config_file_path, "w") as f:
                f.writelines(new_lines)
            print(f"✅ 成功移除路径: {path_to_remove} 从配置文件: {config_file_path} 中")
            return True
        else:
            print(f"⚠️  路径: {path_to_remove} 不存在于配置文件中")
            return False
            
    except Exception as e:
        print(f"❌ 移除路径时出错: {e}")
        return False
def main(): 
    # 添加参数
    import argparse
    parser = argparse.ArgumentParser(description="Add or remove path to shell configuration file")
    parser.add_argument("path", help="Path to add or remove from PATH")
    parser.add_argument("--remove", action="store_true", help="Remove path instead of adding")
    args = parser.parse_args()
    # 调用函数
    if args.remove:
        remove_path_from_shrc(args.path)
    else:
        add_path_to_shrc(args.path)


if __name__ == "__main__":
    main()