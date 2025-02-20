#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.254/g' package/base-files/files/bin/config_generate

# Modify default hostname
sed -i 's/OpenWrt/OneCloud/g' package/base-files/files/bin/config_generate

# 替换终端为bash
sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd

# 清理不需要的包并确保需要的包被正确安装
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall2
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/luci/applications/alist
rm -rf feeds/luci/applications/luci-app-diskman
rm -rf feeds/luci/applications/luci-app-frpc
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf feeds/luci/applications/luci-app-turboacc
rm -rf feeds/luci/applications/luci-app-samba4
rm -rf feeds/luci/applications/luci-app-rclone
rm -rf feeds/NueXini_Packages/luci-app-rclone
rm -rf feeds/luci/applications/luci-app-turboacc
rm -rf feeds/NueXini_Packages/luci-app-istoreenhance
rm -rf feeds/NueXini_Packages/luci-app-xunlei
rm -rf feeds/luci/applications/luci-app-vlmcsd

# 拉取需要的额外包
git clone https://github.com/sirpdboy/luci-app-eqosplus.git feeds/luci/applications/luci-app-eqosplus
git clone https://github.com/kiddin9/kwrt-packages


#====================
############################git clone https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/applications/luci-app-eqosplus
#========================

# 移动需要的包到正确位置
cd kwrt-packages && mv luci-app-chinadns-ng luci-app-cpu-perf vmease openwrt-natmapt natter2 autoshare-samba luci-app-dockerman luci-app-natmapt luci-app-natter2 luci-app-onliner luci-app-rtbwmon luci-app-frpc luci-app-istoredup luci-app-istoreenhance luci-app-istorego luci-app-istorepanel luci-app-rclone luci-app-samba4 luci-app-turboacc luci-app-wolplus luci-app-xunlei ../feeds/luci/applications/
cd ../ && rm -rf kwrt-packages

# 更新和安装feeds，确保包被正确处理
./scripts/feeds update -a
./scripts/feeds install -a

# 重新运行 make menuconfig 以确保这些包已经被选中
# 编译前确保选中的包都已启用，更新 .config
make defconfig
