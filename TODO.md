# TODO: 修复 find_containments_id.py 脚本

## 任务概述
修复 `src/find_containments_id.py` 中的 `find_containments_id` 函数，使其查找 KDE Plasma 配置文件中所有 TARGET_PLUGIN 对应的 [Containments][xxx] ID，并返回列表。支持多行文本查找。

## 步骤
- [x] 修改函数以收集所有匹配的 ID 到列表
- [x] 当匹配到 TARGET_PLUGIN 时，添加到列表
- [x] 返回列表，如果未找到返回空列表
- [x] 更新 main 函数以打印所有 ID
- [x] 添加可选的 text 参数以支持多行文本查找
- [x] 测试脚本，确保返回 ['574'] 对于 "plugin=org.kde.plasma.folder"
- [x] 测试多行文本查找功能
