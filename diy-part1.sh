#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default





#rm -rf feeds/luci/applications/luci-app-mosdns




# Add a feed source
# echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"



echo "src-git NueXini_Packages https://github.com/NueXini/NueXini_Packages.git" >> "feeds.conf.default"
echo 'src-git kenzok8 https://github.com/kenzok8/small' >> feeds.conf.default
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
echo 'src-git alist https://github.com/sbwml/luci-app-alist' >> feeds.conf.default
#{
#  echo "src-git NueXini_Packages https://github.com/NueXini/NueXini_Packages.git";
#  echo "src-git kenzok8 https://github.com/kenzok8/small";
#  echo "src-git kenzo https://github.com/kenzok8/openwrt-packages";
#  cat feeds.conf.default;
#} > feeds.conf.default.tmp && mv feeds.conf.default.tmp feeds.conf.default

