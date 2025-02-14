#!/bin/bash
#
# 最终优化版编译脚本（保留手动移动操作）
#

# ==== 基础配置 ====
sed -i 's/192.168.1.1/192.168.11.254/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/OneCloud/g' package/base-files/files/bin/config_generate
sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd

# ==== 清理冲突包 ====
declare -a CONFLICT_PKGS=(
    "feeds/luci/applications/luci-app-passwall"
    "feeds/luci/applications/luci-app-passwall2"
    # ... [其他需要删除的包路径] ...
)

for pkg in "${CONFLICT_PKGS[@]}"; do
    echo "移除冲突包: $pkg"
    rm -rf "$pkg"
done

# ==== 核心包移动操作 ====
(
    # 原子化操作：克隆仓库并移动指定包
    git clone --depth=1 https://github.com/kiddin9/kwrt-packages kwrt-temp
    cd kwrt-temp
    
    # 要移动的包列表
    move_list=(
        luci-app-chinadns-ng luci-app-cpu-perf 
        vmease openwrt-natmapt natter2 
        autoshare-samba luci-app-dockerman 
        luci-app-natmapt luci-app-natter2 
        luci-app-onliner luci-app-rtbwmon 
        luci-app-frpc luci-app-istoredup 
        luci-app-istoreenhance luci-app-istorego 
        luci-app-istorepanel luci-app-rclone 
        luci-app-samba4 luci-app-turboacc 
        luci-app-wolplus luci-app-xunlei
    )
    
    # 批量移动并验证
    for pkg in "${move_list[@]}"; do
        if [ -d "$pkg" ]; then
            echo "移动: $pkg => ../feeds/NueXini_Packages/"
            mv -f "$pkg" ../feeds/NueXini_Packages/
        else
            echo "警告: $pkg 不存在于仓库中"
        fi
    done
)
rm -rf kwrt-temp  # 清理临时目录

# ==== 特殊包安装 ====
git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus.git \
    feeds/luci/applications/luci-app-eqosplus

# ==== 依赖修复 ====
# 修复核心依赖链
rm -rf package/lean/autosamba
[ -d feeds/NueXini_Packages/luci-app-samba4 ] && \
    ln -sf ../feeds/NueXini_Packages/luci-app-samba4 \
        feeds/luci/applications/luci-app-samba4

# ==== Feed系统更新 ====
# 强制重建索引（关键步骤）
./scripts/feeds clean
./scripts/feeds update -a -f
./scripts/feeds install -a -f --force-overwrite

# ==== 编译前验证 ====
# 检查关键包路径
echo "关键包状态验证:"
ls -d feeds/NueXini_Packages/luci-app-{samba4,dockerman,frpc} 2>/dev/null

# 检查菜单配置中的包
echo "在menuconfig中确认以下包是否存在:"
grep -E 'CONFIG_PACKAGE_luci-app-(samba4|dockerman|frpc)' .config || true
