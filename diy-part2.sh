#!/bin/bash
#
# 优化后的编译脚本（保留手动移动包逻辑）
#

# ====== 基础设置 ======
sed -i 's/192.168.1.1/192.168.11.254/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/OneCloud/g' package/base-files/files/bin/config_generate
sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd

# ====== 移除冲突包 ======
declare -a REMOVE_PKGS=(
    "feeds/luci/applications/luci-app-passwall"
    "feeds/luci/applications/luci-app-passwall2"
    "feeds/luci/applications/luci-app-alist"
    "feeds/luci/applications/alist"
    "feeds/luci/applications/luci-app-diskman"
    "feeds/luci/applications/luci-app-frpc"
    "feeds/luci/applications/luci-app-dockerman"
    "feeds/luci/applications/luci-app-turboacc"
    "feeds/luci/applications/luci-app-samba4"
    "feeds/luci/applications/luci-app-rclone"
    "feeds/luci/applications/luci-app-vlmcsd"
    "feeds/NueXini_Packages/luci-app-rclone"
    "feeds/NueXini_Packages/luci-app-istoreenhance"
    "feeds/NueXini_Packages/luci-app-xunlei"
)

for pkg in "${REMOVE_PKGS[@]}"; do
    echo "移除冲突包: $pkg"
    rm -rf "${pkg}"
done

# ====== 核心包移动操作 ======
# 定义原子化移动函数
move_packages() {
    repo_url="https://github.com/kiddin9/kwrt-packages"
    work_dir="kwrt-packages-workdir"
    
    # 克隆仓库
    git clone --depth=1 "$repo_url" "$work_dir"
    
    # 定义要移动的包列表
    declare -a packages=(
        luci-app-chinadns-ng luci-app-cpu-perf vmease 
        openwrt-natmapt natter2 autoshare-samba 
        luci-app-dockerman luci-app-natmapt luci-app-natter2 
        luci-app-onliner luci-app-rtbwmon luci-app-frpc 
        luci-app-istoredup luci-app-istoreenhance luci-app-istorego 
        luci-app-istorepanel luci-app-rclone luci-app-samba4 
        luci-app-turboacc luci-app-wolplus luci-app-xunlei
    )
    
    # 移动包并验证
    cd "$work_dir" && \
    for pkg in "${packages[@]}"; do
        if [ -d "$pkg" ]; then
            echo "移动包: $pkg => ../feeds/NueXini_Packages/"
            mv -f "$pkg" ../feeds/NueXini_Packages/
        else
            echo "警告: 包 $pkg 不存在于仓库中"
        fi
    done
    
    cd .. && rm -rf "$work_dir"
}

# 执行移动操作
move_packages

# ====== 特殊包安装 ======
git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus.git \
    feeds/luci/applications/luci-app-eqosplus

# ====== 依赖修复 ======
# 修复samba4依赖链
rm -rf package/lean/autosamba
if [ -d "feeds/NueXini_Packages/luci-app-samba4" ]; then
    ln -sf ../feeds/NueXini_Packages/luci-app-samba4 \
        feeds/luci/applications/luci-app-samba4
fi

# ====== Feed系统更新 ======
# 强制更新并建立索引
./scripts/feeds update -a -f
./scripts/feeds install -a -f --force-overwrite

# ====== 最终验证 ======
echo "关键包路径验证:"
ls -dl feeds/NueXini_Packages/luci-app-{samba4,dockerman,frpc} 2>/dev/null

echo "当前已安装的luci-app列表:"
./scripts/feeds list | grep 'luci-app'
