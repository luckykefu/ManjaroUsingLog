---
created: 2024-04-06T00:00:00.000Z
---

# Conda

恢复默认源

```
conda config --remove-key channels
```

1. **创建新的环境**：
```bash
conda create --name myenv python=3.8
```

2. **激活环境**：
```bash
conda activate myenv
```

3. **列出所有可用的环境**：
```bash
conda env list
```

4. **安装包**：
```bash
conda install numpy
```

5. **更新包**：
```bash
conda update numpy
```

6. **删除包**：
```bash
conda remove numpy
```

7. **查找包**：
```bash
conda search numpy
```

8. **列出环境中安装的包**：
```bash
conda list
```

9. **导出环境文件**：
```bash
conda env export > environment.yml
```

10. **从文件创建环境**：
```bash
conda env create -f environment.yml
```

11. **清理缓存**：
```bash
conda clean --all
```
