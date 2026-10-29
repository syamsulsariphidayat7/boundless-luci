#!/bin/sh
# ==========================================================================
#  luci-theme-boundless - uninstall / rollback (OpenWrt, ash)
#  Mengembalikan tema aktif ke tema sebelum install (disimpan install.sh
#  di /etc/boundless-previous-theme), default-nya bootstrap.
#  Tambahkan argumen --remove-files untuk ikut menghapus file tema.
# ==========================================================================
set -e

PREV="/luci-static/bootstrap"
if [ -f /etc/boundless-previous-theme ]; then
	PREV=$(cat /etc/boundless-previous-theme)
fi
# Jangan rollback ke diri sendiri
[ "$PREV" = "/luci-static/boundless" ] && PREV="/luci-static/bootstrap"

echo "[boundless] Mengembalikan tema aktif ke: $PREV"
uci set luci.main.mediaurlbase="$PREV"
uci -q delete luci.themes.Boundless || true
uci commit luci

if [ "$1" = "--remove-files" ]; then
	echo "[boundless] Menghapus file tema..."
	rm -rf /www/luci-static/boundless
	rm -f /www/luci-static/resources/menu-boundless.js
	rm -rf /usr/share/ucode/luci/template/themes/boundless
	rm -f /etc/boundless-previous-theme
fi

rm -rf /tmp/luci-modulecache /tmp/luci-indexcache 2>/dev/null || true
/etc/init.d/uhttpd restart
echo "[boundless] Rollback selesai. Refresh LuCI."
