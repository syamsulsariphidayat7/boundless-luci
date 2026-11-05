# Changelog

## [2.4.0] - 2026-11-05

### Changed

- **Cek update tidak lagi otomatis** (permintaan Syamsul):
  halaman dashboard tidak memeriksa GitHub saat dibuka; cek
  hanya berjalan bila tombol **Cek Update** diklik. Baris status
  awal kini mengarahkan ke tombol itu.
- **Label posisi dock lebih jelas**: pilihan yang tadinya
  "Bawah / Kanan Bawah" menjadi **"Tengah Bawah"** dan
  **"Pojok Kanan Bawah"**, ditambah satu baris penjelasan di
  kartu Dock tentang letak masing-masing.

## [2.3.3] - 2026-11-05

### Changed

- Label opsi posisi "Kanan" menjadi **"Kanan Bawah"** mengikuti
  perilaku barunya di tema 2.3.3 (dock menempel di pojok kanan
  bawah). Nilai UCI tetap `right`.

## [2.3.2] - 2026-11-05

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 2.3.2 (perubahan ada di tema: teks
dock kanan sejajar).

## [2.3.1] - 2026-11-05

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 2.3.1 (perubahan ada di tema:
perbaikan tampilan dock kanan).

## [2.3.0] - 2026-11-05

### Added

- **Pengaturan posisi dock: Bawah atau Kanan** (permintaan
  Syamsul). Pemilih "Posisi Dock" di kartu Dock tersimpan di UCI
  `boundlesstheme.settings.dock_position`, berlaku langsung
  (POST `dock_pos`, sejajar seperti endpoint lain) dan ikut
  ditulis ke `dock-data.js` sebagai `BOUNDLESS_DOCK_POS` —
  diterapkan tema lewat kelas `dock-right`. Bawaan: Bawah.
  `GET dock` kini juga mengembalikan `pos` untuk editor.

## [2.2.2] - 2026-11-03

### Added

- **Geser urutan item dock dengan seret & letakkan** (permintaan
  Syamsul): pegangan grip di kiri tiap baris editor Dock, didrag
  dengan Pointer Events (mouse dan sentuh; bukan drag HTML5 lama
  yang tidak jalan di layar sentuh). Baris berpindah langsung
  mengikuti pointer dan urutan tersimpan saat Simpan Dock
  ditekan. Tombol &#8593; &#8595; tetap ada sebagai cadangan.

## [2.2.1] - 2026-11-03

### Fixed

- **Tombol Simpan Dock di 2.2.0 tidak benar-benar menyimpan.**
  Endpoint simpan/reset/halaman terdaftar bersarang di bawah
  entry `dock` yang `.leaf`, sehingga dispatcher menyerahkan
  segment ekstra ke `action_dock` sebagai argumen: POST simpan
  dijawab `ok` tanpa `count` dan tanpa menulis UCI (pesan sukses
  di dashboard menampilkan "undefined item"). Endpoint kini
  sejajar seperti endpoint lain: `dock`, `dock_save`,
  `dock_reset`, `dock_pages`; URL di dashboard disesuaikan.
  Pelajaran: jangan beri `.leaf` pada entry yang punya anak.

## [2.2.0] - 2026-11-03

### Added

- **Manajemen Dock dari dashboard** (permintaan Syamsul): kartu
  "Dock" baru untuk tambah / hapus / geser urutan item dock,
  ganti ikon dan warna per item, aktif/nonaktif, dan buka di tab
  baru. Item tersimpan sebagai section UCI bertipe `dock` di
  config `boundlesstheme` dan ditulis ke
  `/www/luci-static/boundless/dock-data.js` untuk digambar tema.
  Tanpa konfigurasi tersimpan, berlaku 9 item bawaan (dock sampai
  2.1.6 persis, termasuk warnanya).
- **Pustaka ikon tanpa upload**: 53 ikon Material Symbols
  (`usr/lib/lua/luci/boundlesstheme/icons.lua`, nama → path SVG).
  Pemilih ikon di dashboard berupa grid klik; ikon item custom di
  luar pustaka tidak didukung (cukup tambah baris di file itu).
- Endpoint baru: `GET dock` (item + pustaka ikon; sekaligus
  menulis ulang dock-data.js), `POST dock/save` (validasi label,
  href, ikon, warna; maks 14 item), `POST dock/reset` (kembali ke
  bawaan), `GET dock/pages` (daftar halaman LuCI terpasang dari
  pohon menu, untuk dropdown pemilih href; href manual tetap
  bisa, termasuk pola `{host}` untuk alamat dinamis).
- `install.sh` memasang `icons.lua` (+ verifikasi), `uninstall.sh`
  menghapus modul ikon dan `dock-data.js`.

## [2.1.6] - 2026-11-03

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 2.1.6 (perubahan ada di tema: ikon dock
berwarna per item).

## [2.1.5] - 2026-11-03

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 2.1.5 (perubahan ada di tema: item dock
"Tools" menuju Boundless Tools).

## [2.1.4] - 2026-11-03

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 2.1.4 (perubahan ada di tema: item dock
"Sinyal" & "SMS" baru, ikon modem/monitor duplikat di header
dihapus).

## [2.1.3] - 2026-11-03

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 2.1.3 (perubahan ada di tema: item dock
baru "Sunset").

## [2.1.2] - 2026-10-30

### Changed

- Tombol reset slider Efek Glass dipindah ke samping saklar
  **Efek Glass** (sebaris dengan Terapkan Skema), bergaya tombol
  primer bergradien seperti tombol lain, dan namanya dipendekkan
  jadi **"Reset Opacity"** (permintaan Syamsul). Tombol hanya
  tampil saat Efek Glass menyala, sejalan dengan slidernya;
  fungsi tidak berubah (kembali ke 68 / 68 / 42 / 50, pratinjau
  + simpan otomatis).

## [2.1.1] - 2026-10-30

### Added

- **Tombol "Reset ke Default"** di blok slider Efek Glass:
  mengembalikan keempat opacity ke nilai bawaan (Header 68%,
  Dock 68%, Sidebar 42%, Kartu 50%) — pratinjau langsung lalu
  tersimpan otomatis, sama seperti menggeser slider.

### Fixed

- **Ruang kosong besar di bawah kartu dashboard**: baris status
  (`.btw-statusline`) selalu menyisakan tempat walau kosong
  (min-height 18px + margin, ×3 baris di kartu Ganti Tema ≈
  84px). Baris status kosong sekarang tidak ditampilkan
  (`:empty`), jadi kartu rapat mengikuti isinya; pesan status
  tetap muncul seperti biasa saat ada isinya.

## [2.1.0] - 2026-10-30

### Added

- **4 slider opacity Efek Glass** di kartu Ganti Tema — Header
  40–95%, Dock 40–95%, Sidebar 20–85%, Kartu 30–90% (default
  nilai 2.0.2: 68 / 68 / 42 / 50; header & dock sengaja terpisah
  atas permintaan Syamsul) — tampil hanya saat Efek Glass
  menyala. Geser = pratinjau langsung di halaman, lepas =
  tersimpan otomatis ke UCI (`glass_header` / `glass_dock` /
  `glass_side` / `glass_card`). Endpoint `POST /material`
  memvalidasi rentang di server (di luar rentang = 400) dan
  menulis variabel opacity ke `material.css`; endpoint status
  melaporkan nilai aktif, dan habis Install/Update nilai slider
  diterapkan ulang otomatis bersama pilihan material.

## [2.0.2] - 2026-10-30

Tidak ada perubahan kode aplikasi pada rilis ini — nomor versi
mengikuti rilis gabungan 2.0.2 (perubahan ada di tema: Efek Glass
dikuatkan).

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
