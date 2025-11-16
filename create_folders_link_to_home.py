# 创建符号链接
# 将user下所有文件夹创建符号链接到主目录
import os
if __name__ == "__main__":
    path=os.path.join(os.getcwd(),"user")
    list_dirs = [d for d in os.listdir(path) if os.path.isdir(os.path.join(path, d))]
    print(list_dirs)
    links= [(os.path.join(path, name), os.path.expanduser(f"~/{name}")) for name in list_dirs]
    print(links)
    from src.create_link import LinkManager 
    LinkManager.bulk_create_links(links)    
    