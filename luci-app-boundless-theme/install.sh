#!/bin/sh
# ==========================================================================
#  luci-app-boundless-theme - installer (OpenWrt, ash)
#  Jalankan DARI DALAM folder aplikasi ini di STB, contoh:
#     cd /tmp/luci-app-boundless-theme && sh install.sh
#  Memasang panel kelola tema Boundless di LuCI (System -> Boundless
#  Theme). File lama langsung ditimpa (tanpa folder backup,
#  biar /root bersih); config yang sudah ada selalu dipertahankan.
# ==========================================================================
if [ ! -f /etc/openwrt_release ]; then
  echo "STOP: script ini untuk DI DALAM STB (OpenWrt), bukan di PC/laptop."
  echo "Kirim folder aplikasi ke STB lalu jalankan di sana, contoh:"
  echo "  scp -r luci-app-boundless-theme root@192.168.1.1:/tmp/"
  echo "  ssh root@192.168.1.1 'cd /tmp/luci-app-boundless-theme && sh install.sh'"
  exit 1
fi
set -e

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CTL="usr/lib/lua/luci/controller/boundlesstheme.lua"
VIEW="usr/lib/lua/luci/view/boundlesstheme"

if [ ! -f "$DIR/$CTL" ] || [ ! -f "$DIR/$VIEW/dashboard.htm" ]; then
  echo "[boundless-app] ERROR: file aplikasi tidak lengkap di $DIR" >&2
  echo "[boundless-app] Jalankan script dari dalam folder luci-app-boundless-theme." >&2
  exit 1
fi

VER=$(cat "$DIR/VERSION" 2>/dev/null || echo "?")
echo "[boundless-app] luci-app-boundless-theme v$VER"

echo "[boundless-app] Menyalin file..."
mkdir -p /usr/lib/lua/luci/controller "/$VIEW"
cp -f "$DIR/$CTL" "/$CTL"
cp -f "$DIR/$VIEW/dashboard.htm" "/$VIEW/dashboard.htm"
cp -f "$DIR/$VIEW/VERSION" "/$VIEW/VERSION"
if [ -f /etc/config/boundlesstheme ]; then
  echo "[boundless-app] Config yang sudah ada dipertahankan"
else
  cp -f "$DIR/etc/config/boundlesstheme" /etc/config/boundlesstheme
fi
chmod 644 "/$CTL" "/$VIEW/dashboard.htm" "/$VIEW/VERSION"

echo "[boundless-app] Membersihkan cache LuCI + restart uhttpd..."
rm -f /tmp/luci-indexcache /tmp/luci-indexcache.* 2>/dev/null || true
rm -rf /tmp/luci-modulecache /tmp/luci-modulecache.* 2>/dev/null || true
/etc/init.d/uhttpd restart

echo "[boundless-app] Verifikasi:"
grep -q "luci.controller.boundlesstheme" "/$CTL" && echo "[boundless-app] controller OK"
[ -f /etc/config/boundlesstheme ] && echo "[boundless-app] config OK"
echo "[boundless-app] SELESAI. Buka LuCI -> System -> Boundless Theme (hard refresh: Ctrl+F5)."
