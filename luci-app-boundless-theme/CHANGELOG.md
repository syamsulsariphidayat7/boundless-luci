# Changelog

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
