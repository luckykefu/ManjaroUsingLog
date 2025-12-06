import os
import re
from pathlib import Path

# 定义全局变量来跟踪修改次数
# 在这个结构中，我们必须将 changed_count 设为全局变量
changed_count = 0 

# =======将导出的chrome标签的文件夹名称转为小写===============

def load_file(input_path):
    """加载文件,路径处理"""
    input_path = os.path.expanduser(input_path)
    input_path = Path(input_path)
    
    # 1. 读取原始文件内容
    try:
        # 使用 'r' 模式读取，以保证兼容性
        with open(input_path, encoding="utf-8") as f:
            content = f.read()
    except FileNotFoundError:
        print(f"❌ 错误：文件未找到于 {input_path}")
        return None # 返回 None 表示文件加载失败
    
    return content

def save_file(new_content, input_path):
    """保存新文件"""
    input_path = os.path.expanduser(input_path)
    input_path = Path(input_path)
    
    # 定义输出路径
    output_path = input_path.parent / (input_path.stem + "_lower_fixed" + input_path.suffix)
    
    # 3. 保存新文件
    try:
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(new_content)
        print("\n✅ 完成！")
        print(f"共修改了 {changed_count} 个文件夹名称")
        print(f"新文件已保存为：  {output_path}")
    except Exception as e:
        print(f"❌ 写入文件时发生错误: {e}")
        return

def lower_folder(match):
    """
    re.sub() 调用的替换函数。
    它接收一个 re.Match 对象。
    """
    global changed_count # 声明使用全局变量
    
    # match.group(2) 是 <H3> 和 </H3> 之间的原始文本
    original_text = match.group(2)
    
    # **关键步骤：去除首尾空白和换行，然后转换为小写**
    stripped_original = original_text.strip()
    lowercase_text = stripped_original.lower()
    
    # 只有在发生变化时才计数和打印
    if lowercase_text != stripped_original:
        print(f"修改: 「{stripped_original}」 → 「{lowercase_text}」")
        changed_count += 1
        
    # 返回替换后的整个字符串: <H3>小写文本</H3>
    # match.group(1) 是 <H3...> 标签
    # match.group(3) 是 </H3> 标签
    return match.group(1) + lowercase_text + match.group(3)


# --- 主执行流程 ---

f = "~/Documents/bookmarks_12_4_25.html"

# 1. 加载文件内容
content_data = load_file(f)

if content_data is None:
    # 文件加载失败，退出
    exit() 

# 2. 编译正则表达式
p = re.compile(r'(<H3\b[^>]*>)(.*?)(</H3>)', re.IGNORECASE | re.DOTALL)

# 3. 执行替换
# 将 lower_folder 函数本身作为参数传递给 sub()
new_content = p.sub(lower_folder, content_data)

# 4. 打印匹配结果（可选，用于调试）
# print("\n--- 调试输出（findall 结果）---")
# print(p.findall(content_data))

# 5. 保存新文件
save_file(new_content, f)