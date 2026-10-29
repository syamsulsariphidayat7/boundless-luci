# Changelog

## [1.6.0] - 2026-10-30

### Changed

- **Tombol Install / Update kini bersyarat**: tersembunyi secara
  bawaan dan hanya muncul bila cek update menyatakan ada versi
  baru. Cek berjalan **otomatis saat halaman dibuka** (tombol Cek
  Update tetap ada untuk memeriksa ulang manual); bila sudah versi
  terbaru, gagal cek, atau GitHub tak terjangkau, tombol tetap
  sembunyi dan alasannya tertulis di baris status.

## [1.5.0] - 2026-10-30

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 1.5.0 (perubahan ada di tema: tanda titik
dock kini di semua item, tidak aktif redup).

## [1.4.0] - 2026-10-30

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 1.4.0 (perubahan ada di tema: tanda titik
untuk item dock yang aktif).

## [1.3.0] - 2026-10-30

### Changed

- **Panel kini mengikuti skema aktif**: gradien + warna primer panel
  (judul, ikon kartu, tombol) memakai skema yang sedang diterapkan —
  bukan lagi selalu bawaan. Panel berubah seketika habis skema
  diterapkan (dari data status, tanpa refresh); warna semantik
  (hijau aktif, merah hapus) tetap.
- Pesan selesai terapkan skema: redaksi "hard refresh" dilunakkan
  menjadi "refresh" (refresh biasa memang cukup).

## [1.2.0] - 2026-10-29

### Changed

- **Install / Update kini memasang dua-duanya**: unduh tarball rilis
  boundless-luci, jalankan `install.sh` tema lalu `install.sh`
  aplikasi ini sendiri (**update diri**, pola hg680pcls) — ke
  depannya semua update cukup dari dashboard; one-liner curl tinggal
  untuk pasang pertama / pemulihan. Kegagalan salah satu komponen
  membuat keseluruhan proses ditandai gagal di log.

### Fixed

- README aplikasi: daftar fitur dilengkapi (Ganti Tema + Skema
  Warna) dan paragraf pembuka yang rusak tersambung diperbaiki.

## [1.1.0] - 2026-10-29

### Added

- **Kontrol Skema Warna** menyatu di kartu Ganti Tema: grup dropdown
  skema + strip pratinjau gradien + tombol Terapkan Skema, hanya
  muncul saat tema yang dipilih adalah Boundless. Lima skema:
  Love Couple (bawaan), Pun Yeta, Sand to Blue, Purplepine,
  Deep Space. Pilihan disimpan di UCI
  (`boundlesstheme.settings.scheme`) dan diterapkan dengan menulis
  `scheme.css` tema (endpoint POST `scheme`; status menyertakan
  skema aktif + daftar skema).

## [1.0.0] - 2026-10-29

Rilis pertama sebagai bagian dari proyek gabungan
[boundless-luci](https://github.com/syamsulsariphidayat7/boundless-luci)
— dashboard dan tema berbagi satu nomor versi (versi bundle).
Panel kelola tema luci-theme-boundless di LuCI
(System → Boundless Theme).

### Added

- Dashboard status: versi tema terpasang, tema aktif, installer lokal.
- Cek update dari repo boundless-luci (membaca `VERSION` tema pada
  tag rilis terbaru) + catatan rilis dari `CHANGELOG.md` tema.
- Install/Update satu klik: unduh tarball rilis bundle, jalankan
  `install.sh` tema dari subfoldernya — berjalan di latar belakang
  dengan log terpantau, tahan restart uhttpd.
- Kartu Ganti Tema: dropdown tema terdaftar (`luci.themes`) +
  tombol Aktifkan, pengganti dropdown Design di Language and Style.
- Rollback dan Hapus Tema satu klik (`uninstall.sh` tema, dengan
  fallback lokal bila perangkat offline).
- Pola keamanan & proses mengikuti hg680pcls: POST + token CSRF,
  proses detached dengan file log/rc/pid, satu proses pada satu waktu.
