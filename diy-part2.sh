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

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
sed -i 's/OpenWrt/OneCloud/g' package/base-files/files/bin/config_generate

# 替换终端为bash
sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

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
git clone https://github.com/sirpdboy/luci-app-eqosplus.git feeds/luci/applications/luci-app-eqosplus
git clone https://github.com/kiddin9/kwrt-packages
cd kwrt-packages && mv luci-app-chinadns-ng luci-app-cpu-perf luci-app-dockerman luci-app-natmapt luci-app-natter2 luci-app-onliner luci-app-rtbwmon luci-app-frpc luci-app-istoredup luci-app-istoreenhance luci-app-istorego luci-app-istorepanel luci-app-rclone luci-app-samba4 luci-app-turboacc luci-app-wolplus luci-app-xunlei ../feeds/NueXini_Packages/
cd ../ && rm -rf kwrt-packages
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-chinadns-ng
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-cpu-perf
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-dockerman
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-natmapt
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-natter2
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-onliner
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-rtbwmon
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-frpc
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-istoredup
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-istoreenhance
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-istorego
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-istorepanel
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-rclone
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-samba4
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-turboacc
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-wolplus
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-xunlei
./scripts/feeds update -a
./scripts/feeds install -a
