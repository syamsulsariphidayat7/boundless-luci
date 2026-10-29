#!/bin/sh
# ==========================================================================
#  luci-theme-boundless - installer manual untuk OpenWrt 24.10 (ash)
#  Jalankan DARI DALAM folder tema ini di STB, contoh:
#     cd /tmp/luci-theme-boundless && sh install.sh
#  (file tema harus sudah ada di STB - scp/rsync folder ini dari PC kamu)
#
#  Script ini TIDAK menghapus tema lain. Tema sebelumnya (biasanya
#  bootstrap) tetap terpasang dan dipakai untuk rollback - lihat README.
# ==========================================================================
set -e

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ ! -f "$DIR/htdocs/luci-static/boundless/cascade.css" ]; then
	echo "[boundless] ERROR: cascade.css tidak ditemukan di $DIR" >&2
	echo "[boundless] Jalankan script dari dalam folder luci-theme-boundless." >&2
	exit 1
fi

VER=$(cat "$DIR/VERSION" 2>/dev/null || echo "?")
echo "[boundless] luci-theme-boundless v$VER"

# Ingat tema aktif sekarang, buat rollback gampang
PREV=$(uci -q get luci.main.mediaurlbase || echo "/luci-static/bootstrap")
echo "$PREV" > /etc/boundless-previous-theme
echo "[boundless] Tema aktif sekarang: $PREV (disimpan di /etc/boundless-previous-theme)"

echo "[boundless] Menyalin file tema..."
# Skema warna pilihan user (ditulis dashboard ke scheme.css di folder
# statis tema) jangan sampai hilang gara-gara install ulang: simpan
# dulu file yang sedang aktif, kembalikan setelah penyalinan selesai.
SCHEME_BAK=""
if [ -f /www/luci-static/boundless/scheme.css ]; then
	SCHEME_BAK=$(mktemp)
	cp -f /www/luci-static/boundless/scheme.css "$SCHEME_BAK" 2>/dev/null || SCHEME_BAK=""
fi
# Static files (CSS / logo / icon) -> /www/luci-static/...
mkdir -p /www/luci-static/boundless /www/luci-static/resources
cp -r "$DIR/htdocs/luci-static/boundless/." /www/luci-static/boundless/
cp -f "$DIR/htdocs/luci-static/resources/menu-boundless.js" /www/luci-static/resources/

# Kembalikan skema warna pilihan user (lihat catatan di atas)
if [ -n "$SCHEME_BAK" ] && [ -f "$SCHEME_BAK" ]; then
	cp -f "$SCHEME_BAK" /www/luci-static/boundless/scheme.css
	rm -f "$SCHEME_BAK"
fi

# Ikon navbar REYRE-WRT (v7): header tema ini menampilkan baris ikon
# shortcut (nikki/openclash/tinyfm/dll) yang gambarnya tinggal di folder
# navbar/ tema material bawaan firmware. Aset itu milik firmware, jadi
# TIDAK dibundel di repo ini - kalau foldernya ada di STB, salin ke tema
# ini supaya ikonnya tidak 404. Di firmware non-REYRE-WRT langkah ini
# ke-skip sendiri (baris ikonnya tinggal kosong/broken-image dari
# template, sama seperti perilaku tema material REYRE-WRT di mesin lain).
if [ -d /www/luci-static/material/navbar ]; then
	echo "[boundless] Menyalin ikon navbar dari tema material bawaan..."
	cp -r /www/luci-static/material/navbar /www/luci-static/boundless/
fi

# Template ucode (yang dipakai OpenWrt 24.10) -> /usr/share/ucode/luci/template/themes/...
mkdir -p /usr/share/ucode/luci/template/themes/boundless
cp -f "$DIR/ucode/template/themes/boundless/header.ut" /usr/share/ucode/luci/template/themes/boundless/
cp -f "$DIR/ucode/template/themes/boundless/footer.ut" /usr/share/ucode/luci/template/themes/boundless/

# Catatan: template legacy luasrc/*.htm SENGAJA tidak diinstall.
# OpenWrt 24.10 tidak memakainya untuk tema (lihat README bagian Struktur).

echo "[boundless] Mendaftarkan tema di UCI..."
uci set luci.themes.Boundless='/luci-static/boundless'
uci set luci.main.mediaurlbase='/luci-static/boundless'
uci commit luci

# Bersihkan cache LuCI supaya tema baru langsung dipakai
rm -rf /tmp/luci-modulecache /tmp/luci-indexcache 2>/dev/null || true
rm -f /tmp/luci-*cache* 2>/dev/null || true

echo "[boundless] Restart uhttpd..."
/etc/init.d/uhttpd restart

echo ""
echo "[boundless] SELESAI. Refresh LuCI (hard refresh: Ctrl+F5)."
echo "[boundless] Kalau tampilan rusak / tidak bisa masuk:"
echo "  ssh ke STB lalu jalankan:  sh uninstall.sh   (dari folder tema ini)"
echo "  atau manual:  uci set luci.main.mediaurlbase='$PREV'; uci commit luci; /etc/init.d/uhttpd restart"
echo ""
