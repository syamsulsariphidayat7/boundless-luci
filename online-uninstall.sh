#!/bin/sh
# ==========================================================================
#  boundless-luci - pencopot ONLINE paket gabungan (OpenWrt, ash)
#  Mencopot TEMA (luci-theme-boundless) + DASHBOARD
#  (luci-app-boundless-theme) dari STB:
#    * tema aktif diganti ke bawaan dulu (Material/bootstrap),
#      registrasi + semua file tema dihapus
#    * controller, view, dan config dashboard dihapus
#  Sekali restart uhttpd di akhir. Folder *-backup di /root SENGAJA
#  tidak ikut dihapus (jejak rollback); lihat catatan di akhir.
#
#  Satu baris di STB:
#     curl -fsSL https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/online-uninstall.sh | sh
#  atau kalau curl tidak ada:
#     wget -qO- https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/online-uninstall.sh | sh
# ==========================================================================
if [ ! -f /etc/openwrt_release ]; then
  echo "STOP: script ini untuk DI DALAM STB (OpenWrt), bukan di PC/laptop."
  echo "Script ini tidak mengubah apa pun di mesin ini."
  exit 1
fi
set -e

echo "[copot] 1/4 Ganti tema aktif ke bawaan dulu (supaya LuCI aman)..."
if [ -d /www/luci-static/material ]; then
  FALLBACK="/luci-static/material"
else
  FALLBACK="/luci-static/bootstrap"
fi
uci set luci.main.mediaurlbase="$FALLBACK"
uci -q delete luci.themes.Boundless || true
uci commit luci
echo "[copot] Tema aktif sekarang: $FALLBACK"

echo "[copot] 2/4 Hapus file tema Boundless..."
rm -rf /www/luci-static/boundless
rm -rf /usr/share/ucode/luci/template/themes/boundless
rm -rf /usr/lib/lua/luci/view/themes/boundless
rm -f /www/luci-static/resources/menu-boundless.js
rm -f /etc/boundless-previous-theme
rm -rf /root/luci-theme-boundless

echo "[copot] 3/4 Hapus dashboard (luci-app-boundless-theme)..."
rm -f /usr/lib/lua/luci/controller/boundlesstheme.lua
rm -rf /usr/lib/lua/luci/view/boundlesstheme
rm -f /etc/config/boundlesstheme
rm -f /root/luci-app-boundless-theme-uninstall.sh

echo "[copot] 4/4 Bersihkan cache LuCI + restart uhttpd..."
rm -f /tmp/luci-indexcache /tmp/luci-indexcache.* 2>/dev/null || true
rm -rf /tmp/luci-modulecache /tmp/luci-modulecache.* 2>/dev/null || true
rm -f /tmp/boundlesstheme-*.log /tmp/boundlesstheme-*.rc /tmp/boundlesstheme-*.pid 2>/dev/null || true
/etc/init.d/uhttpd restart

echo ""
echo "[copot] ===== Verifikasi ====="
echo "[copot] mediaurlbase: $(uci -q get luci.main.mediaurlbase)"
if uci -q get luci.themes.Boundless >/dev/null; then
  echo "[copot] PERINGATAN: registrasi luci.themes.Boundless masih ada"
else
  echo "[copot] Registrasi Boundless: bersih"
fi
[ -e /www/luci-static/boundless ] && echo "[copot] PERINGATAN: /www/luci-static/boundless masih ada" || echo "[copot] File tema: bersih"
[ -e /usr/lib/lua/luci/controller/boundlesstheme.lua ] && echo "[copot] PERINGATAN: controller dashboard masih ada" || echo "[copot] File dashboard: bersih"
echo ""
echo "[copot] SELESAI. LuCI sekarang memakai tema bawaan ($FALLBACK)."
echo "[copot] Catatan: folder backup /root/*-backup/ TIDAK ikut dihapus."
echo "[copot] Kalau mau bersih total: rm -rf /root/*-backup /root/luci-app-boundless-theme-backup"
echo "[copot] Pasang lagi: curl -fsSL https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/online-install.sh | sh"
