"""
Python bridge module for ASMR app.
Loaded by Chaquopy on Android.
Manages extension scripts and provides the scraping interface to Flutter.
"""
import json
import os
import importlib.util
import sys
from typing import Any, Dict, List, Optional


class ExtensionRegistry:
    def __init__(self, extensions_dir: str):
        self.extensions_dir = extensions_dir
        self._extensions: Dict[str, Any] = {}

    def discover_extensions(self) -> List[Dict[str, str]]:
        manifests = []
        if not os.path.isdir(self.extensions_dir):
            return manifests
        for fname in os.listdir(self.extensions_dir):
            if fname.endswith(".py") and not fname.startswith("_"):
                path = os.path.join(self.extensions_dir, fname)
                mod = self._load_module(path, fname[:-3])
                if mod and hasattr(mod, "metadata"):
                    try:
                        meta = mod.metadata()
                        meta["file"] = fname
                        manifests.append(meta)
                        self._extensions[meta["id"]] = mod
                    except Exception as e:
                        print(f"Failed to load extension {fname}: {e}")
        return manifests

    def _load_module(self, path: str, mod_name: str):
        spec = importlib.util.spec_from_file_location(mod_name, path)
        if spec and spec.loader:
            mod = importlib.util.module_from_spec(spec)
            sys.modules[mod_name] = mod
            spec.loader.exec_module(mod)
            return mod
        return None

    def get_extension(self, source_id: str):
        ext = self._extensions.get(source_id)
        if not ext:
            raise ValueError(f"Extension '{source_id}' not found")
        return ext

    def search(self, source_id: str, query: str, page: int = 1) -> List[Dict]:
        ext = self.get_extension(source_id)
        return list(ext.search(query, page))

    def get_popular(self, source_id: str, page: int = 1) -> List[Dict]:
        ext = self.get_extension(source_id)
        return list(ext.get_popular(page))

    def get_latest(self, source_id: str, page: int = 1) -> List[Dict]:
        ext = self.get_extension(source_id)
        if hasattr(ext, "get_latest"):
            return list(ext.get_latest(page))
        return list(ext.get_popular(page))

    def get_audio_details(self, source_id: str, url: str) -> Dict:
        ext = self.get_extension(source_id)
        return dict(ext.get_audio_details(url))

    def get_download_urls(self, source_id: str, url: str) -> List[Dict]:
        ext = self.get_extension(source_id)
        return list(ext.get_download_urls(url))


_registry: Optional[ExtensionRegistry] = None


def _get_registry() -> ExtensionRegistry:
    global _registry
    if _registry is None:
        extensions_dir = os.path.join(
            os.path.dirname(__file__), "..", "..", "..", "..", "python_extensions"
        )
        _registry = ExtensionRegistry(extensions_dir)
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
