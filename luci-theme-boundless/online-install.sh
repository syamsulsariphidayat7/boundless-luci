#!/bin/sh
# ==========================================================================
#  luci-theme-boundless - installer ONLINE dari GitHub (OpenWrt, ash)
#
#  Tema ini sekarang tinggal di repo gabungan "boundless-luci" (satu
#  repo untuk tema + dashboard). Satu baris di STB (repo harus SUDAH
#  di-push & Public):
#     curl -fsSL https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/luci-theme-boundless/online-install.sh | sh
#  atau kalau curl tidak ada (OpenWrt bawaan biasanya hanya punya wget):
#     wget -qO- https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/luci-theme-boundless/online-install.sh | sh
#
#  Yang didownload adalah tarball RILIS TERBARU repo boundless-luci
#  (tag git terakhir), lalu folder luci-theme-boundless di dalamnya
#  dipasang - bukan isi branch yang masih berubah-ubah. Pilihan lain:
#     VERSION=1.1.0 sh online-install.sh   -> paksa tag rilis tertentu
#     BRANCH=main  sh online-install.sh    -> ambil branch mentah (dev)
#  Kalau repo belum punya tag sama sekali, otomatis jatuh ke branch main.
#
#  Folder tema disimpan di /root/luci-theme-boundless (SENGAJA tidak
#  dihapus, supaya uninstall.sh tetap bisa dijalankan untuk rollback),
#  lalu install.sh dijalankan dari sana.
# ==========================================================================
set -e

REPO="syamsulsariphidayat7/boundless-luci"
DEST="/root/luci-theme-boundless"

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

# Tentukan ref yang mau didownload: tag rilis (default) atau branch.
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
fetch "$URL" "$TMPD/theme.tar.gz"

echo "[boundless] Ekstrak..."
tar -xzf "$TMPD/theme.tar.gz" -C "$TMPD"
# Tema ada di subfolder luci-theme-boundless di dalam tarball repo gabungan.
SRC=$(find "$TMPD" -maxdepth 3 -type d -name 'luci-theme-boundless' | head -1)
if [ -z "$SRC" ] || [ ! -f "$SRC/install.sh" ]; then
	echo "[boundless] ERROR: folder tema tidak ditemukan di dalam tarball." >&2
	echo "[boundless] Cek lagi: repo sudah di-push? ref '$REFDESC' ada? repo Public?" >&2
	exit 1
fi

rm -rf "$DEST"
cp -r "$SRC" "$DEST"
echo "[boundless] Folder tema disimpan di $DEST (untuk rollback: sh $DEST/uninstall.sh)"

cd "$DEST"
sh install.sh
