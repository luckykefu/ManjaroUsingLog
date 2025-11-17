import os
import shutil
from pathlib import Path

class LinkManager:
    """Manage symbolic links with additional utilities"""
    
    @staticmethod
    def create_link(source_dir, target_dir, create_source=True, overwrite=True):
        """
        Create symbolic link with comprehensive options
        """
        try:
            source_dir = os.path.expanduser(source_dir)
            target_dir = os.path.expanduser(target_dir)
            source_dir = os.path.abspath(source_dir)
            target_dir = os.path.abspath(target_dir)
            source = Path(source_dir)
            target = Path(target_dir)


            
            
            # Check if target exists and handle accordingly
            if target.exists() or target.is_symlink():
                if not overwrite:
                    print(f"⚠️  Target exists and overwrite=False: {target_dir}")
                    return False
                
                if target.is_symlink():
                    target.unlink()
                elif target.is_dir():
                    shutil.rmtree(target)
                else:
                    target.unlink()
                print(f"🗑️  Removed existing target: {target_dir}")
            
            # Create source directory if needed
            if create_source and not source.exists():
                source.mkdir(parents=True, exist_ok=True)
                print(f"📁 Created source directory: {source_dir}")
            
            # Create the symbolic link
            target.symlink_to(source.resolve())
            print(f"✅ Created symbolic link: {target_dir} -> {source_dir}")
            return True
            
        except Exception as e:
            print(f"❌ Failed to create symbolic link: {e}")
            return False
    
    @staticmethod
    def check_link(target_dir):
        """
        Comprehensive link checking
        """
        try:
            target = Path(target_dir)
            
            if not target.exists():
                return {
                    'status': 'missing',
                    'message': f"❌ Target does not exist: {target_dir}",
                    'valid': False
                }
            
            if target.is_symlink():
                link_target = target.readlink()
                target_exists = link_target.exists()
                
                if target_exists:
                    return {
                        'status': 'valid',
                        'message': f"✅ Valid symbolic link: {target_dir} -> {link_target}",
                        'target': str(link_target),
                        'target_exists': True,
                        'valid': True
                    }
                else:
                    return {
                        'status': 'broken',
                        'message': f"⚠️  Broken symbolic link: {target_dir} -> {link_target} (target missing)",
                        'target': str(link_target),
                        'target_exists': False,
                        'valid': False
                    }
            else:
                item_type = 'directory' if target.is_dir() else 'file'
                return {
                    'status': 'not_link',
                    'message': f"❌ Not a symbolic link: {target_dir} (it's a {item_type})",
                    'type': item_type,
                    'valid': False
                }
                
        except Exception as e:
            return {
                'status': 'error',
                'message': f"❌ Error checking link: {e}",
                'valid': False,
                'error': str(e)
            }
    
    @staticmethod
    def bulk_create_links(links, create_sources=True, overwrite=True):
        """
        Create multiple symbolic links at once
        
        Args:
            links (list): List of (source, target) tuples
            create_sources (bool): Whether to create source directories
            overwrite (bool): Whether to overwrite existing targets
        """
        results = []
        for source, target in links:
            success = LinkManager.create_link(source, target, create_sources, overwrite)
            results.append({
                'source': source,
                'target': target,
                'success': success
            })
        return results

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Create symbolic links")
    parser.add_argument("source", help="Source directory")
    parser.add_argument("target", help="Target directory")
    parser.add_argument("--create-source", action="store_true", help="Create source directory if it doesn't exist")
    parser.add_argument("--overwrite", action="store_true", help="Overwrite existing targets")
    args = parser.parse_args()
    # 调用函数
    LinkManager.create_link(args.source, args.target, args.create_source, args.overwrite)
# Usage examples
if __name__ == "__main__":
    main()
    # source_dir=os.path.join(os.getcwd(), 'user', '.pip')
    # target_dir="~/.pip"
    # Using the class
    # LinkManager.create_link(source_dir, os.path.expanduser(target_dir))
    
    # # Bulk creation
    # links = [
    #     (pip_dir, os.path.expanduser("~/.pip"))
    # ]
    # LinkManager.bulk_create_links(links)