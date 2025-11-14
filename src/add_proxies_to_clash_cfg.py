import yaml
import json
import argparse
from pathlib import Path
from typing import List, Dict, Any, Union

class ClashConfigManager:
    """Clash 配置文件管理器"""
    
    def __init__(self, config_path: str = "~/.config/clash/config.yaml"):
        self.config_path = Path(config_path).expanduser()
    
    def create_default_config(self) -> Dict[str, Any]:
        """创建默认的 Clash 配置"""
        return {
            # HTTP(S) 代理服务端口
            'port': 7890,
            
            # SOCKS5 代理服务端口  
            'socks-port': 7891,
            
            # 设置为 true 以允许来自其他 LAN IP 地址的连接
            'allow-lan': False,
            
            # 混合端口（同时支持 HTTP 和 SOCKS5）
            'mixed-port': 7890,
            
            # 红帽模式
            'redir-port': 7892,
            
            # TProxy 端口
            'tproxy-port': 7893,
            
            # Clash 路由工作模式
            # rule: 基于规则的数据包路由
            # global: 所有数据包将被转发到单个节点  
            # direct: 直接将数据包转发到互联网
            'mode': 'rule',
            
            # 日志级别: info / warning / error / debug / silent
            'log-level': 'info',
            
            # IPv6 支持
            'ipv6': False,
            
            # RESTful Web API 监听地址
            'external-controller': '127.0.0.1:9090',
            
            # 外部 UI 设置（可选）
            'external-ui': 'dashboard',
            
            # 配置文件目录
            'config-directory': str(self.config_path.parent),
            
            # 代理服务器配置
            'proxies': [],
            
            # 代理组配置
            'proxy-groups': [
                {
                    'name': '🚀 自动选择',
                    'type': 'url-test',
                    'proxies': ['DIRECT'],
                    'url': 'http://www.gstatic.com/generate_204',
                    'interval': 300
                },
                {
                    'name': '🔀 负载均衡', 
                    'type': 'load-balance',
                    'proxies': ['DIRECT'],
                    'url': 'http://www.gstatic.com/generate_204',
                    'interval': 300
                },
                {
                    'name': '🎯 手动选择',
                    'type': 'select',
                    'proxies': ['DIRECT', '🚀 自动选择', '🔀 负载均衡']
                },
                {
                    'name': '🎮 游戏模式',
                    'type': 'select',
                    'proxies': ['🚀 自动选择', '🎯 手动选择', 'DIRECT']
                },
                {
                    'name': '📱 流媒体',
                    'type': 'select', 
                    'proxies': ['🎯 手动选择', '🚀 自动选择', 'DIRECT']
                }
            ],
            
            # 规则配置
            'rules': self._get_default_rules()
        }
    
    def _get_default_rules(self) -> List[str]:
        """获取默认规则列表"""
        return [
            # 本地网络直连
            'DOMAIN-SUFFIX,local,DIRECT',
            'IP-CIDR,127.0.0.0/8,DIRECT', 
            'IP-CIDR,10.0.0.0/8,DIRECT',
            'IP-CIDR,172.16.0.0/12,DIRECT',
            'IP-CIDR,192.168.0.0/16,DIRECT',
            'IP-CIDR,100.64.0.0/10,DIRECT',
            
            # 广告屏蔽
            'DOMAIN-KEYWORD,adservice,REJECT',
            'DOMAIN-SUFFIX,doubleclick.net,REJECT',
            'DOMAIN-SUFFIX,googlesyndication.com,REJECT',
            'DOMAIN-SUFFIX,googleadservices.com,REJECT',
            'DOMAIN-SUFFIX,adsystem.com,REJECT',
            
            # 国内直连
            'GEOIP,CN,DIRECT',
            
            # 常用国外网站走代理
            'DOMAIN-SUFFIX,google.com,🎯 手动选择',
            'DOMAIN-SUFFIX,gstatic.com,🎯 手动选择', 
            'DOMAIN-SUFFIX,googleapis.com,🎯 手动选择',
            'DOMAIN-SUFFIX,github.com,🎯 手动选择',
            'DOMAIN-SUFFIX,github.io,🎯 手动选择',
            'DOMAIN-SUFFIX,githubassets.com,🎯 手动选择',
            'DOMAIN-SUFFIX,gitlab.com,🎯 手动选择',
            
            # 流媒体服务
            'DOMAIN-SUFFIX,youtube.com,📱 流媒体',
            'DOMAIN-SUFFIX,ytimg.com,📱 流媒体',
            'DOMAIN-SUFFIX,netflix.com,📱 流媒体',
            'DOMAIN-SUFFIX,nflxext.com,📱 流媒体',
            'DOMAIN-SUFFIX,nflxso.net,📱 流媒体',
            'DOMAIN-SUFFIX,disneyplus.com,📱 流媒体',
            'DOMAIN-SUFFIX,hulu.com,📱 流媒体',
            
            # 游戏相关
            'DOMAIN-SUFFIX,steamcommunity.com,🎮 游戏模式',
            'DOMAIN-SUFFIX,steampowered.com,🎮 游戏模式',
            
            # 最终规则
            'MATCH,🎯 手动选择'
        ]
    
    def create_config(self) -> Path:
        """创建 Clash 配置文件"""
        config = self.create_default_config()
        
        self.config_path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(self.config_path, 'w', encoding='utf-8') as f:
            yaml.dump(config, f, allow_unicode=True, default_flow_style=False, sort_keys=False)
        
        print(f"✅ Clash 配置文件已创建: {self.config_path}")
        self._print_config_info()
        
        return self.config_path
    
    def _print_config_info(self):
        """打印配置信息"""
        print("\n📋 配置信息:")
        print("📍 HTTP/SOCKS5 代理: 127.0.0.1:7890")
        print("📍 控制面板: http://127.0.0.1:9090")
        print("📝 代理组: 🚀 自动选择, 🔀 负载均衡, 🎯 手动选择, 🎮 游戏模式, 📱 流媒体")
        print("💡 使用 'add-proxies' 命令添加代理服务器")
    
    def add_proxies(self, proxies: List[Union[Dict, str]], update_groups: bool = True) -> Path:
        """
        添加代理到配置文件
        
        Args:
            proxies: 代理配置列表（字典或JSON字符串）
            update_groups: 是否更新代理组
        """
        if not self.config_path.exists():
            print("❌ 配置文件不存在，创建新配置...")
            self.create_config()
        
        with open(self.config_path, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        # 解析代理配置
        parsed_proxies = self._parse_proxies(proxies)
        
        # 添加新代理
        config['proxies'].extend(parsed_proxies)
        
        # 更新代理组
        if update_groups:
            self._update_proxy_groups(config, parsed_proxies)
        
        # 保存配置
        with open(self.config_path, 'w', encoding='utf-8') as f:
            yaml.dump(config, f, allow_unicode=True, default_flow_style=False, sort_keys=False)
        
        print(f"✅ 已添加 {len(parsed_proxies)} 个代理到配置文件")
        return self.config_path
    
    def _parse_proxies(self, proxies: List[Union[Dict, str]]) -> List[Dict]:
        """解析代理配置"""
        parsed_proxies = []
        for proxy in proxies:
            if isinstance(proxy, dict):
                parsed_proxies.append(proxy)
            else:
                try:
                    parsed_proxy = json.loads(proxy)
                    parsed_proxies.append(parsed_proxy)
                except json.JSONDecodeError:
                    print(f"❌ 无法解析代理配置: {proxy}")
        
        return parsed_proxies
    
    def _update_proxy_groups(self, config: Dict, new_proxies: List[Dict]):
        """更新代理组"""
        proxy_names = [p['name'] for p in new_proxies if p.get('type') not in ['direct', 'reject']]
        
        for group in config['proxy-groups']:
            if group['name'] not in ['DIRECT', 'REJECT']:
                # 添加新代理到现有组（避免重复）
                for proxy_name in proxy_names:
                    if proxy_name not in group['proxies']:
                        group['proxies'].append(proxy_name)
    
    def list_proxies(self):
        """列出所有代理"""
        if not self.config_path.exists():
            print("❌ 配置文件不存在")
            return
        
        with open(self.config_path, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        print(f"\n📊 当前代理列表 ({len(config['proxies'])} 个):")
        for i, proxy in enumerate(config['proxies'], 1):
            print(f"  {i}. {proxy['name']} ({proxy.get('type', 'unknown')})")
    
    def show_config_info(self):
        """显示配置信息"""
        if not self.config_path.exists():
            print("❌ 配置文件不存在")
            return
        
        with open(self.config_path, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        print(f"\n📋 配置文件: {self.config_path}")
        print(f"📍 代理端口: {config.get('port', 'N/A')}")
        print(f"🌐 工作模式: {config.get('mode', 'N/A')}")
        print(f"📊 代理数量: {len(config.get('proxies', []))}")
        print(f"👥 代理组: {len(config.get('proxy-groups', []))}")
        print(f"📜 规则数量: {len(config.get('rules', []))}")

def main():
    """主函数"""
    parser = argparse.ArgumentParser(description='Clash 配置文件管理器')
    subparsers = parser.add_subparsers(dest='command', help='可用命令')
    
    # 创建配置命令
    create_parser = subparsers.add_parser('create', help='创建新的 Clash 配置')
    create_parser.add_argument('--config', default='~/.config/clash/config.yaml', 
                              help='配置文件路径')
    
    # 添加代理命令
    add_parser = subparsers.add_parser('add-proxies', help='添加代理到配置')
    add_parser.add_argument('proxies', nargs='+', help='代理配置（JSON格式）')
    add_parser.add_argument('--config', default='~/.config/clash/config.yaml',
                           help='配置文件路径')
    
    # 列出代理命令
    list_parser = subparsers.add_parser('list-proxies', help='列出所有代理')
    list_parser.add_argument('--config', default='~/.config/clash/config.yaml',
                            help='配置文件路径')
    
    # 显示信息命令
    info_parser = subparsers.add_parser('info', help='显示配置信息')
    info_parser.add_argument('--config', default='~/.config/clash/config.yaml',
                            help='配置文件路径')
    
    args = parser.parse_args()
    
    manager = ClashConfigManager(args.config)
    
    if args.command == 'create':
        manager.create_config()
    elif args.command == 'add-proxies':
        manager.add_proxies(args.proxies)
    elif args.command == 'list-proxies':
        manager.list_proxies()
    elif args.command == 'info':
        manager.show_config_info()
    else:
        parser.print_help()

if __name__ == "__main__":
    main()