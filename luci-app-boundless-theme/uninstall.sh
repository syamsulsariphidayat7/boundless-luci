#!/bin/sh
# ==========================================================================
#  luci-app-boundless-theme - uninstall aplikasi pengelola (OpenWrt, ash)
#  Menghapus panel kelola (controller, view, config). Tema Boundless
#  sendiri TIDAK ikut terhapus - hapus tema lewat dashboard-nya atau
#  uninstall.sh milik tema.
# ==========================================================================
if [ ! -f /etc/openwrt_release ]; then
  echo "STOP: script ini untuk DI DALAM STB (OpenWrt), bukan di PC/laptop."
  exit 1
fi
set -e

echo "[boundless-app] Menghapus file aplikasi pengelola..."
rm -f /usr/lib/lua/luci/controller/boundlesstheme.lua
rm -rf /usr/lib/lua/luci/view/boundlesstheme
rm -f /etc/config/boundlesstheme

echo "[boundless-app] Membersihkan cache LuCI + restart uhttpd..."
rm -f /tmp/luci-indexcache /tmp/luci-indexcache.* 2>/dev/null || true
rm -rf /tmp/luci-modulecache /tmp/luci-modulecache.* 2>/dev/null || true
/etc/init.d/uhttpd restart

echo "[boundless-app] SELESAI. Menu System -> Boundless Theme sudah hilang."
