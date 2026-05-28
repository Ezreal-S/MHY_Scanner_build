#!/bin/bash
# 本地 CI 模拟构建脚本
# 用于推送前验证构建是否通过

set -e

echo "=========================================="
echo "本地 CI 验证构建"
echo "=========================================="

# 检查 vcpkg
if [ -z "$VCPKG_ROOT" ]; then
    echo "错误: VCPKG_ROOT 未设置"
    echo "请先设置: export VCPKG_ROOT=/path/to/vcpkg"
    exit 1
fi

# 使用 CI 相同的 preset
PRESET="Release-CI"

echo ""
echo "[1/3] 配置 CMake..."
cmake --preset $PRESET \
    -DVCPKG_INSTALLED_DIR="$VCPKG_ROOT/installed"

echo ""
echo "[2/3] 构建项目..."
cmake --build --preset $PRESET

echo ""
echo "[3/3] 检查产物..."
APP_PATH="${PRESET}_build/bin/Release/MHY_Scanner.app"
if [ -d "$APP_PATH" ]; then
    echo "✅ 构建成功: $APP_PATH"
    ls -la "${PRESET}_build/bin/Release/"
else
    echo "❌ 构建失败: App 未生成"
    exit 1
fi

echo ""
echo "=========================================="
echo "✅ 本地验证通过，可以推送"
echo "=========================================="
