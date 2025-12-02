#!/usr/bin/env python3
"""
excalidraw_local.py - 完全离线的Excalidraw转视频工具
无需网络连接，只需Python和FFmpeg
"""

import os
import sys
import json
import subprocess
import tempfile
from pathlib import Path

class ExcalidrawOfflineConverter:
    def __init__(self):
        self.check_dependencies()
        
    def check_dependencies(self):
        """检查必要的依赖"""
        # 检查FFmpeg
        try:
            subprocess.run(['ffmpeg', '-version'], 
                         capture_output=True, check=True)
            print("✅ FFmpeg 已安装")
        except:
            print("❌ 需要安装FFmpeg")
            print("Ubuntu/Debian: sudo apt install ffmpeg")
            print("macOS: brew install ffmpeg")
            print("Windows: 从 https://ffmpeg.org/download.html 下载")
            sys.exit(1)
            
    def parse_excalidraw_json(self, json_path):
        """解析Excalidraw JSON文件"""
        with open(json_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # 提取元素信息
        elements = data.get('elements', [])
        
        # 计算画布边界
        min_x = min(e.get('x', 0) for e in elements)
        min_y = min(e.get('y', 0) for e in elements)
        max_x = max(e.get('x', 0) + e.get('width', 0) for e in elements)
        max_y = max(e.get('y', 0) + e.get('height', 0) for e in elements)
        
        return {
            'elements': elements,
            'bounds': {
                'x': min_x, 'y': min_y,
                'width': max_x - min_x,
                'height': max_y - min_y
            },
            'appState': data.get('appState', {})
        }
    
    def create_svg_from_elements(self, data, scale=1.0):
        """从元素数据创建SVG（简化版）"""
        bounds = data['bounds']
        
        svg_content = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" 
     width="{bounds['width'] * scale}" 
     height="{bounds['height'] * scale}" 
     viewBox="{bounds['x']} {bounds['y']} {bounds['width']} {bounds['height']}">
    <rect width="100%" height="100%" fill="white"/>
    <g transform="scale({scale})">
'''
        
        # 添加每个元素（简化实现）
        for element in data['elements']:
            if element.get('type') == 'rectangle':
                svg_content += self._create_rect_svg(element)
            elif element.get('type') == 'text':
                svg_content += self._create_text_svg(element)
        
        svg_content += '</g></svg>'
        return svg_content
    
    def _create_rect_svg(self, element):
        """创建矩形SVG"""
        return f'''
    <rect x="{element['x']}" 
          y="{element['y']}" 
          width="{element['width']}" 
          height="{element['height']}" 
          fill="white" 
          stroke="#000" 
          stroke-width="2"/>
'''
    
    def _create_text_svg(self, element):
        """创建文本SVG"""
        return f'''
    <text x="{element['x']}" 
          y="{element['y'] + 20}" 
          font-family="Arial" 
          font-size="20" 
          fill="black">
        {element.get('text', '')}
    </text>
'''
    
    def convert_to_video(self, input_path, output_path, options=None):
        """主转换函数"""
        options = options or {}
        scale = options.get('scale', 2.0)  # 默认放大2倍
        
        # 创建临时目录
        with tempfile.TemporaryDirectory() as tmpdir:
            print(f"📁 临时目录: {tmpdir}")
            
            # 解析Excalidraw文件
            print("📄 解析Excalidraw文件...")
            data = self.parse_excalidraw_json(input_path)
            
            # 创建SVG
            print("🎨 生成SVG...")
            svg_content = self.create_svg_from_elements(data, scale)
            
            svg_path = os.path.join(tmpdir, 'temp.svg')
            with open(svg_path, 'w', encoding='utf-8') as f:
                f.write(svg_content)
            
            # 使用FFmpeg转换
            print("🎬 生成视频...")
            self._ffmpeg_convert(svg_path, output_path, options)
            
        print(f"✅ 视频已生成: {output_path}")
    
    def _ffmpeg_convert(self, svg_path, output_path, options):
        """使用FFmpeg转换SVG到视频"""
        duration = options.get('duration', 10)  # 默认10秒
        fps = options.get('fps', 30)
        
        # 创建视频
        cmd = [
            'ffmpeg', '-y',
            '-loop', '1',
            '-i', svg_path,
            '-t', str(duration),
            '-c:v', 'libx264',
            '-pix_fmt', 'yuv420p',
            '-vf', f'fps={fps},scale=1920:1080:force_original_aspect_ratio=increase',
            output_path
        ]
        
        subprocess.run(cmd, check=True)

# 使用示例
if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("使用方法: python excalidraw_local.py input.excalidraw output.mp4")
        print("可选参数: --scale 2.0 --duration 10 --fps 30")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    # 解析可选参数
    options = {}
    for i in range(3, len(sys.argv), 2):
        if sys.argv[i] == '--scale':
            options['scale'] = float(sys.argv[i+1])
        elif sys.argv[i] == '--duration':
            options['duration'] = int(sys.argv[i+1])
        elif sys.argv[i] == '--fps':
            options['fps'] = int(sys.argv[i+1])
    
    # 运行转换
    converter = ExcalidrawOfflineConverter()
    converter.convert_to_video(input_file, output_file, options)