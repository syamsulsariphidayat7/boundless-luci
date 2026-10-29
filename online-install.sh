#!/bin/sh
# ==========================================================================
#  boundless-luci - installer ONLINE paket gabungan (OpenWrt, ash)
#  Memasang TEMA (luci-theme-boundless) + DASHBOARD
#  (luci-app-boundless-theme) sekali jalan, dari GitHub.
#
#  Satu baris di STB (repo harus SUDAH di-push & Public):
#     curl -fsSL https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/online-install.sh | sh
#  atau kalau curl tidak ada (OpenWrt bawaan biasanya hanya punya wget):
#     wget -qO- https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/online-install.sh | sh
#
#  Yang didownload adalah tarball RILIS TERBARU repo ini (tag git
#  terakhir), lalu install.sh tema dan install.sh dashboard dijalankan
#  dari subfolder masing-masing. Pilihan lain:
#     VERSION=1.0.0 sh online-install.sh   -> paksa tag rilis tertentu
#     BRANCH=main  sh online-install.sh    -> ambil branch mentah (dev)
#  Kalau repo belum punya tag sama sekali, otomatis jatuh ke branch main.
#  Folder tema disimpan ke /root/luci-theme-boundless supaya
#  uninstall.sh tema selalu tersedia di dalam STB untuk rollback.
# ==========================================================================
set -e

REPO="syamsulsariphidayat7/boundless-luci"

TMPD=$(mktemp -d)
trap 'rm -rf "$TMPD"' EXIT INT TERM

fetch() { # $1=url $2=output-file
	if command -v curl >/dev/null 2>&1; then
		curl -fsSL "$1" -o "$2"
	elif command -v wget >/dev/null 2>&1; then
		wget -q -O "$2" "$1"
	else
		echo "[boundless] ERROR: curl dan wget tidak ditemukan." >&2
		echo "[boundless] Install salah satu dulu, misal: opkg update && opkg install curl" >&2
		echo "[boundless] (di OpenWrt 24.10 berbasis apk: apk update && apk add curl)" >&2
		exit 1
	fi
}

REFDESC=""
if [ -n "$BRANCH" ]; then
	URL="https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz"
	REFDESC="branch $BRANCH"
elif [ -n "$VERSION" ]; then
	TAG="v${VERSION#v}"
	URL="https://github.com/$REPO/archive/refs/tags/$TAG.tar.gz"
	REFDESC="rilis $TAG"
else
	TAG=""
	if fetch "https://api.github.com/repos/$REPO/tags?per_page=1" "$TMPD/tags.json" 2>/dev/null; then
		TAG=$(grep -o '"name": *"[^"]*"' "$TMPD/tags.json" | head -1 | sed 's/.*"\([^"]*\)"$/\1/')
	fi
	if [ -n "$TAG" ]; then
		URL="https://github.com/$REPO/archive/refs/tags/$TAG.tar.gz"
		REFDESC="rilis terbaru $TAG"
	else
		echo "[boundless] Repo belum punya tag rilis; pakai branch main."
		URL="https://github.com/$REPO/archive/refs/heads/main.tar.gz"
		REFDESC="branch main"
	fi
fi

echo "[boundless] Download $REFDESC: $URL ..."
fetch "$URL" "$TMPD/bundle.tar.gz"

echo "[boundless] Ekstrak..."
tar -xzf "$TMPD/bundle.tar.gz" -C "$TMPD"
ROOT=$(find "$TMPD" -maxdepth 1 -type d -name 'boundless-luci-*' | head -1)
THEME_DIR="$ROOT/luci-theme-boundless"
APP_DIR="$ROOT/luci-app-boundless-theme"
if [ -z "$ROOT" ] || [ ! -f "$THEME_DIR/install.sh" ] || [ ! -f "$APP_DIR/install.sh" ]; then
	echo "[boundless] ERROR: isi tarball tidak seperti yang diharapkan." >&2
	echo "[boundless] Cek lagi: repo sudah di-push? ref '$REFDESC' ada? repo Public?" >&2
	exit 1
fi

# Jaga penanda tema-sebelumnya (sama seperti script pasang lokal).
CUR=$(uci -q get luci.main.mediaurlbase || echo "")
SAVED_PREV=""
if [ "$CUR" = "/luci-static/boundless" ] && [ -f /etc/boundless-previous-theme ]; then
	SAVED_PREV=$(cat /etc/boundless-previous-theme)
fi

echo ""
echo "[boundless] ===== 1/2 Memasang TEMA ====="
( cd "$THEME_DIR" && sh install.sh )
if [ -n "$SAVED_PREV" ]; then
	echo "$SAVED_PREV" > /etc/boundless-previous-theme
	echo "[boundless] Penanda tema-sebelumnya dikembalikan ke: $SAVED_PREV"
fi
rm -rf /root/luci-theme-boundless
cp -r "$THEME_DIR" /root/luci-theme-boundless

echo ""
echo "[boundless] ===== 2/2 Memasang DASHBOARD ====="
( cd "$APP_DIR" && sh install.sh )
cp -f "$APP_DIR/uninstall.sh" /root/luci-app-boundless-theme-uninstall.sh
chmod 755 /root/luci-app-boundless-theme-uninstall.sh

echo ""
echo "[boundless] SELESAI ($REFDESC). Buka LuCI -> System -> Boundless Theme (hard refresh: Ctrl+F5)."
echo "[boundless] Rollback tema:     sh /root/luci-theme-boundless/uninstall.sh"
echo "[boundless] Copot dashboard:   sh /root/luci-app-boundless-theme-uninstall.sh"
