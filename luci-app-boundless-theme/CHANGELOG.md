# Changelog

## [2.0.1] - 2026-10-30

### Changed

- Saklar **Efek Glass** pindah sebaris dengan kontrol skema
  (di samping tombol Terapkan Skema), tidak lagi di baris
  tersendiri di bawahnya. Perbaikan dock yang terpental saat
  Glass aktif ada di tema (glass.css).

## [2.0.0] - 2026-10-30

### Added

- **Saklar Efek Glass** di kartu Ganti Tema (sebaris di bawah
  kontrol skema): menyalakan/mematikan gaya kaca buram tema
  Boundless. Endpoint baru `POST /material` (standar|glass,
  tersimpan di UCI `boundlesstheme.settings.material`, ditulis
  ke `material.css` di folder statis tema); endpoint status
  melaporkan pilihan aktif, dan habis Install/Update pilihan
  material diterapkan ulang otomatis seperti skema.

## [1.9.1] - 2026-10-30

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 1.9.1 (perbaikan di tema: sudut header
yang belum rounded).

## [1.9.0] - 2026-10-30

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 1.9.0 (perubahan ada di tema: header +
sidebar rounded melayang).

## [1.8.4] - 2026-10-30

### Removed

- **Backup file di installer aplikasi dihapus**: `install.sh`
  tidak lagi membuat `/root/luci-app-boundless-theme-backup/` —
  file lama langsung ditimpa, /root tetap bersih (permintaan
  Syamsul). Config yang sudah ada tetap selalu dipertahankan.
  Rollback aplikasi bila perlu = pasang ulang rilis yang diinginkan
  dari GitHub.

## [1.8.3] - 2026-10-30

### Removed

- Baris **Aplikasi Pengelola** di kartu Status dihapus — sejak
  versi gabungan, nomornya selalu sama dengan versi tema, jadi
  cuma duplikat. Stempel versi aplikasi tetap ada internal
  (footer halaman + endpoint status untuk diagnosis).

## [1.8.2] - 2026-10-30

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 1.8.2 (perubahan ada di tema: ikon di
dock bawah).

## [1.8.1] - 2026-10-30

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 1.8.1 (perubahan ada di tema: item About +
Youtube di dock dihapus).

## [1.8.0] - 2026-10-30

### Added

- **Skema Custom**: entri keenam di dropdown skema. Klik **strip
  pratinjau** untuk membuka modal editor warna — tiga color picker
  (awal gradien, akhir gradien, primer) dengan pratinjau langsung;
  modal terisi awal dari skema yang sedang dipilih di dropdown.
  Warna tersimpan di UCI (`settings.custom_c1/custom_c2/
  custom_primary`), divalidasi hex di controller; stop ketiga
  gradien diturunkan otomatis dari warna akhir (diterangkan 35%).

### Changed

- Habis **Install / Update** selesai, skema terakhir yang tercatat
  di UCI **diterapkan ulang otomatis** (scheme.css ditulis ulang)
  sebelum halaman dimuat ulang — skema, termasuk custom, langsung
  balik habis pasang ulang tanpa klik Terapkan manual.

## [1.7.1] - 2026-10-30

### Changed

- **Tombol Rollback dihapus** (redundan: pindah tema sudah bisa
  dari kartu Ganti Tema) dan tombol **Hapus pindah sebaris** dengan
  Cek Update / Install; judul kartu gabungan jadi
  "Install / Update & Hapus". (Perubahan ini sempat tersiapkan
  untuk 1.7.0 tapi tidak ikut terbit di tag itu — dirilis di sini.)

## [1.7.0] - 2026-10-30

### Changed

- **Kartu Install / Update dan Rollback & Hapus digabung** jadi
  satu kartu "Install / Update, Rollback & Hapus" (garis pemisah
  di antara dua bagiannya) — halaman lebih ringkas; semua tombol,
  status, dan log tetap dengan fungsi yang sama persis. Bingkai
  merah kartu lama hilang; tombol Hapus tetap merah.
- **Deskripsi tiap kartu dipangkas** jadi satu-dua kalimat pendek
  (subjudul halaman, catatan Ganti Tema, catatan update, catatan
  rollback) — fungsi tetap dijelaskan status baris per aksi.

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
