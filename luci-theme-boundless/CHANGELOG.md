# Changelog

Semua perubahan penting tema ini dicatat di sini.
Format mengikuti [Keep a Changelog](https://keepachangelog.com/),
versi mengikuti [Semantic Versioning](https://semver.org/).

## [1.3.0] - 2026-10-30

Tidak ada perubahan kode tema pada rilis ini — nomor versi mengikuti
rilis gabungan 1.3.0 (perubahan ada di aplikasi pengelola: panel
dashboard kini mengikuti skema aktif).

## [1.2.0] - 2026-10-29

Tidak ada perubahan kode tema pada rilis ini — nomor versi mengikuti
rilis gabungan 1.2.0 (perubahan ada di aplikasi pengelola: update
dari dashboard kini memasang tema + aplikasi sekaligus).

## [1.1.0] - 2026-10-29

### Added

- **Dukungan skema warna**: `cascade.css` kini meng-`@import`
  `scheme.css` setelah `custom.css`. File itu terpasang kosong
  (= skema bawaan Love Couple) dan ditulis ulang oleh dashboard
  Boundless Theme saat pengguna memilih skema — variabel gradien +
  primer tertimpa tanpa mengubah file tema lain.
- **Tombol "Tema" di dock bawah** menuju dashboard pengelolaan
  (System → Boundless Theme).
- `install.sh` menjaga `scheme.css` yang sedang aktif agar pilihan
  skema pengguna tidak hilang saat install/update ulang.

## [1.0.0] - 2026-10-29

Rilis pertama sebagai bagian dari proyek gabungan
[boundless-luci](https://github.com/syamsulsariphidayat7/boundless-luci)
— tema dan dashboard berbagi satu nomor versi (versi bundle).
Terpasang dan terverifikasi di STB asli (HG680P, firmware REYRE-WRT,
OpenWrt 24.10.8).

### Added

- Tema LuCI lengkap berbasis `luci-theme-material` resmi (OpenWrt
  24.10) yang dimodernisasi ke Material 3 terang, dengan identitas
  **Boundless** (nama, logo header + favicon "Titik Lepas").
- Palet tonal terang: background `#F4F6FA`, primer datar `#0B486B`,
  gradien khas `#29445E → #89253E` (biru baja → burgundy) di header,
  tombol utama, state aktif, progress bar, dan dock.
- Komponen Material 3: switch & radio, dialog radius 28px, filled
  text field, bar aksi melayang, progress bar dengan label chip,
  ripple saat klik, animasi hover (angkat + kilau) pada tombol.
- Kompatibilitas firmware REYRE-WRT: baris ikon shortcut navbar di
  header, footer Temperature & CPU Usage, dan bar menu
  Modem/Terminal/Yacd/Youtube/About/Clear sebagai dock mengambang
  di tengah bawah; notifikasi Release RAM sebagai toast di atas dock.
- Installer lengkap: `install.sh` (manual, dengan pencatatan tema
  sebelumnya untuk rollback), `uninstall.sh` (rollback /
  `--remove-files`), dan `online-install.sh` (satu baris dari GitHub,
  mendownload rilis terbaru repo boundless-luci).
- Penanda versi di `VERSION`, header `cascade.css`, dan `Makefile` —
  versi terpasang bisa dicek di perangkat dengan
  `grep -m1 "Version:" /www/luci-static/boundless/cascade.css`.
