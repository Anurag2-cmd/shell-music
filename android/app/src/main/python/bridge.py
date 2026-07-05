"""
Python bridge module for ASMR app.
Loaded by Chaquopy on Android.
Manages extension scripts and provides the scraping interface to Flutter.
"""
import json
import os
import importlib.util
import sys
import traceback
from typing import Any, Dict, List, Optional


class ExtensionRegistry:
    """Registry for managing and invoking Python extensions."""

    def __init__(self, asset_dir: str, user_dir: Optional[str] = None):
        self.asset_dir = asset_dir
        self.user_dir = user_dir
        self._extensions: Dict[str, Any] = {}
        print(f"DEBUG: Bridge Registry initialized. Assets: {asset_dir}, User: {user_dir}")

    def discover_extensions(self) -> List[Dict[str, str]]:
        """Scan both asset and user directories for Python extension files."""
        manifests = []

        # Scan built-in assets
        self._scan_dir(self.asset_dir, manifests)

        # Scan user-uploaded directory if it exists
        if self.user_dir and os.path.isdir(self.user_dir):
            self._scan_dir(self.user_dir, manifests)

        print(f"DEBUG: Discovered {len(manifests)} extensions: {[m['id'] for m in manifests]}")
        return manifests

    def _scan_dir(self, directory: str, manifests: List[Dict]):
        if not os.path.isdir(directory):
            print(f"DEBUG: Directory not found: {directory}")
            return

        for fname in os.listdir(directory):
            if fname.endswith(".py") and not fname.startswith("_") and fname != "bridge.py":
                path = os.path.join(directory, fname)
                mod_name = f"ext_{fname[:-3]}"
                mod = self._load_module(path, mod_name)
                if mod and hasattr(mod, "metadata"):
                    try:
                        meta = mod.metadata()
                        meta["file"] = fname
                        manifests.append(meta)
                        self._extensions[meta["id"]] = mod
                    except Exception as e:
                        print(f"DEBUG: Failed to get metadata for {fname}: {e}")

    def _load_module(self, path: str, mod_name: str):
        try:
            spec = importlib.util.spec_from_file_location(mod_name, path)
            if spec and spec.loader:
                mod = importlib.util.module_from_spec(spec)
                sys.modules[mod_name] = mod
                spec.loader.exec_module(mod)
                return mod
        except Exception as e:
            print(f"DEBUG: Error loading module {mod_name} from {path}: {e}")
            traceback.print_exc()
        return None

    def get_extension(self, source_id: str):
        ext = self._extensions.get(source_id)
        if not ext:
            print(f"DEBUG: Extension '{source_id}' not found in registry keys: {list(self._extensions.keys())}")
            raise ValueError(f"Extension '{source_id}' not found")
        return ext

    def search(self, source_id: str, query: str, page: int = 1) -> List[Dict]:
        try:
            ext = self.get_extension(source_id)
            results = list(ext.search(query, page))
            print(f"DEBUG: Search on '{source_id}' returned {len(results)} items")
            return results
        except Exception as e:
            print(f"DEBUG: Search error on '{source_id}': {e}")
            traceback.print_exc()
            return []

    def get_popular(self, source_id: str, page: int = 1) -> List[Dict]:
        try:
            ext = self.get_extension(source_id)
            results = list(ext.get_popular(page))
            print(f"DEBUG: Popular on '{source_id}' returned {len(results)} items")
            return results
        except Exception as e:
            print(f"DEBUG: Popular error on '{source_id}': {e}")
            traceback.print_exc()
            return []

    def get_latest(self, source_id: str, page: int = 1) -> List[Dict]:
        try:
            ext = self.get_extension(source_id)
            if hasattr(ext, "get_latest"):
                results = list(ext.get_latest(page))
            else:
                results = list(ext.get_popular(page))
            print(f"DEBUG: Latest on '{source_id}' returned {len(results)} items")
            return results
        except Exception as e:
            print(f"DEBUG: Latest error on '{source_id}': {e}")
            traceback.print_exc()
            return []

    def get_audio_details(self, source_id: str, url: str) -> Dict:
        try:
            ext = self.get_extension(source_id)
            details = dict(ext.get_audio_details(url))
            print(f"DEBUG: Details for '{url}' on '{source_id}' fetched")
            return details
        except Exception as e:
            print(f"DEBUG: Details error on '{source_id}': {e}")
            traceback.print_exc()
            return {}

    def get_download_urls(self, source_id: str, url: str) -> List[Dict]:
        try:
            ext = self.get_extension(source_id)
            urls = list(ext.get_download_urls(url))
            print(f"DEBUG: Download URLs for '{url}' on '{source_id}' returned {len(urls)} items")
            return urls
        except Exception as e:
            print(f"DEBUG: Download URL error on '{source_id}': {e}")
            traceback.print_exc()
            return []


_registry: Optional[ExtensionRegistry] = None


def initialize(user_ext_dir: Optional[str] = None):
    """Initialize the registry with asset and optional user directories."""
    global _registry
    asset_dir = os.path.dirname(__file__)
    _registry = ExtensionRegistry(asset_dir, user_ext_dir)
    return True


def _get_registry() -> ExtensionRegistry:
    global _registry
    if _registry is None:
        initialize()
    return _registry


def get_installed_extensions() -> str:
    registry = _get_registry()
    manifests = registry.discover_extensions()
    return json.dumps(manifests)


def search(source_id: str, query: str, page: int = 1) -> str:
    registry = _get_registry()
    results = registry.search(source_id, query, page)
    return json.dumps(results)


def get_popular(source_id: str, page: int = 1) -> str:
    registry = _get_registry()
    results = registry.get_popular(source_id, page)
    return json.dumps(results)


def get_latest(source_id: str, page: int = 1) -> str:
    registry = _get_registry()
    results = registry.get_latest(source_id, page)
    return json.dumps(results)


def get_audio_details(source_id: str, url: str) -> str:
    registry = _get_registry()
    result = registry.get_audio_details(source_id, url)
    return json.dumps(result)


def get_download_urls(source_id: str, url: str) -> str:
    registry = _get_registry()
    results = registry.get_download_urls(source_id, url)
    return json.dumps(results)
