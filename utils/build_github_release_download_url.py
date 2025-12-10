import requests

def build_github_release_download_url(releases_url: str, suffix: str) -> str:
    """
    根据GitHub Releases页面URL和文件后缀，构建最新版本下载链接。

    参数:
        releases_url: GitHub仓库的Releases页面URL，格式应为 https://github.com/{owner}/{repo}/releases
        suffix: 要下载的文件的后缀（例如：'x86_64.AppImage'）

    返回:
        最新版本中匹配后缀的文件的直接下载链接。

    异常:
        如果URL格式无效、网络请求失败或未找到匹配文件，将抛出异常。
    """
    # 1. 验证并提取仓库信息
    if not releases_url.endswith('/releases'):
        # 如果URL不以/releases结尾，尝试自动修正（可选）
        releases_url = releases_url.rstrip('/') + '/releases'

    # 移除末尾的 '/releases' 得到基础仓库URL
    base_url = releases_url[:-9]  # '/releases' 长度为9
    parts = base_url.split('/')
    if len(parts) < 5 or parts[2] != 'github.com':
        raise ValueError(f"无效的GitHub URL格式：{releases_url}。预期格式：https://github.com/用户名/仓库名/releases")

    owner, repo = parts[3], parts[4]

    # 2. 调用GitHub API获取最新发布信息
    api_url = f"https://api.github.com/repos/{owner}/{repo}/releases/latest"
    try:
        response = requests.get(api_url)
        response.raise_for_status()  # 如果状态码不是200，抛出异常
        release_data = response.json()
    except requests.exceptions.RequestException as e:
        raise ConnectionError(f"请求GitHub API失败：{e}。请检查网络或URL。")

    # 3. 在发布资源中查找匹配后缀的文件
    assets = release_data.get('assets', [])
    for asset in assets:
        file_name = asset.get('name', '')
        if file_name.endswith(suffix):
            download_url = asset.get('browser_download_url')
            if download_url:
                return download_url

    # 4. 如果未找到，提供详细错误信息
    available_files = [asset.get('name', '') for asset in assets]
    raise FileNotFoundError(
        f"在最新发布（版本：{release_data.get('tag_name', '未知')}）中未找到以 '{suffix}' 结尾的文件。\n"
        f"可用文件：{available_files if available_files else '无'}"
    )

# 使用示例
if __name__ == "__main__":
    try:
        # 替换为您的目标仓库和后缀
        url = "https://github.com/AlexanderP/tesseract-appimage/releases"
        suffix = "x86_64.AppImage"

        download_url = build_github_release_download_url(url, suffix)
        print(f"构建的下载链接：{download_url}")


    except Exception as e:
        print(f"错误：{e}")
