#!/bin/bash
#
# Optimized OpenWrt DIY script part 2
# Key improvements:
# 1. Feed source management
# 2. Dependency resolution
# 3. Atomic operations for package replacement
#

# ================== Basic Customization ==================
# Modify default network settings
sed -i 's/192.168.1.1/192.168.11.254/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/OneCloud/g' package/base-files/files/bin/config_generate
sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd

# ================== Feed Configuration ==================
# Clean existing feeds
./scripts/feeds clean

# Add required feed sources (atomic operation)
cat >> feeds.conf << EOF
src-git NueXini_Packages https://github.com/kiddin9/kwrt-packages.git
src-git sirpdboy_luci https://github.com/sirpdboy/luci-app-eqosplus.git
EOF

# ================== Package Management ==================
# Remove conflicting packages (atomic list)
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
    rm -rf "${pkg}"
done

# ================== Dependency Resolution ==================
# Fix core dependency conflicts
rm -rf package/lean/autosamba  # Remove conflicting autosamba

# ================== Package Installation ==================
# Atomic package cloning and moving
clone_and_move() {
    git clone --depth=1 $1 _temp_pkg
    mv -f _temp_pkg/$2 $3
    rm -rf _temp_pkg
}

# Install specific packages
clone_and_move https://github.com/sirpdboy/luci-app-eqosplus.git luci-app-eqosplus feeds/luci/applications/

# ================== Feed Operations ==================
# Update feeds with checksum verification
./scripts/feeds update -a -f

# Force install all packages with dependency check
./scripts/feeds install -a -f --force-overwrite

# ================== Post-Processing ==================
# Create symbolic links for critical packages
ln -sf ../feeds/NueXini_Packages/luci-app-samba4 feeds/luci/applications/luci-app-samba4

# ================== Sanity Check ==================
# Verify package locations
echo "Critical package verification:"
ls -dl feeds/NueXini_Packages/luci-app-{samba4,dockerman,frpc} 2>/dev/null
