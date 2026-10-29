# luci-app-boundless-theme

Panel kelola untuk tema **luci-theme-boundless** — keduanya tinggal
di repo gabungan [boundless-luci](https://github.com/syamsulsariphidayat7/boundless-luci)
(tema di subfolder `luci-theme-boundless`), dan panel ini mengambil
update untuk dua-duanya dari repo itu. Dipakai langsung dari dalam
LuCI: **System → Boundless Theme**.

Tema LuCI sendiri tidak bisa punya halaman, jadi pengelolaannya tinggal
di aplikasi pendamping kecil ini — pola yang sama seperti
[hg680pcls](https://github.com/syamsulsariphidayat7/hg680pcls):
dashboard-nya hanya kulit tipis di atas script tema yang sudah ada.

## Fitur

- **Status tema**: versi terpasang (dari stempel `Version:` di
  `cascade.css`), tema aktif saat ini, ketersediaan installer lokal.
- **Ganti Tema**: dropdown tema terdaftar (`luci.themes`) + tombol
  Aktifkan — pengganti dropdown *Design* di Language and Style,
  tanpa pindah halaman.
- **Skema Warna**: grup pilihan skema di kartu Ganti Tema (muncul
  saat Boundless yang dipilih): 5 skema — Love Couple (bawaan),
  Pun Yeta, Sand to Blue, Purplepine, Deep Space. Pilihan disimpan
  di UCI dan diterapkan lewat `scheme.css` tema.
- **Cek Update**: bandingkan versi terpasang dengan tag rilis terbaru
  di GitHub + tampilkan catatan rilis dari `CHANGELOG.md` tema.
- **Install / Update**: mengunduh tarball rilis terbaru repo
  boundless-luci lalu menjalankan `install.sh` **tema dan aplikasi
  ini sendiri** (update diri) di latar belakang; kemajuannya
  dipantau lewat log langsung di halaman (proses tahan restart
  `uhttpd` di tengah jalan).
- **Rollback**: menjalankan `uninstall.sh` tema — tema sebelumnya
  diaktifkan lagi, file Boundless tetap ada.
- **Hapus Tema**: `uninstall.sh --remove-files` — semua file tema
  dihapus. Bila unduhan script gagal (offline), controller memakai
  fallback lokal yang setara supaya tombol tetap berfungsi.

Semua aksi tulis wajib POST + token CSRF LuCI. Aplikasi ini sendiri
**tidak** ikut terhapus oleh tombol Hapus Tema; kelola aplikasinya
lewat `uninstall.sh` aplikasi ini.

## Install

Syarat: OpenWrt 24.10 (LuCI ucode + Lua view, seperti firmware
REYRE-WRT di HG680P — tempat aplikasi ini terverifikasi).

Dari PC/laptop, kirim folder ini ke STB lalu jalankan installer-nya:

```sh
scp -r luci-app-boundless-theme root@192.168.1.1:/tmp/
ssh root@192.168.1.1 'cd /tmp/luci-app-boundless-theme && sh install.sh'
```

Lalu buka LuCI → **System → Boundless Theme** (hard refresh `Ctrl+F5`).

File yang ditimpa selama install dibackup ke
`/root/luci-app-boundless-theme-backup/` di STB.

## Uninstall aplikasi

```sh
ssh root@192.168.1.1 'sh /tmp/luci-app-boundless-theme/uninstall.sh'
```

(jalankan dari folder aplikasi di mana pun ia berada di STB; script ini
menghapus controller, view, dan config penanda, lalu restart `uhttpd`.)

## Struktur

| File | Fungsi |
| --- | --- |
| `usr/lib/lua/luci/controller/boundlesstheme.lua` | Routing + endpoint JSON (status/check/update/manage) |
| `usr/lib/lua/luci/view/boundlesstheme/dashboard.htm` | Halaman panel (CSS/JS mandiri, tampil baik di tema LuCI apa pun) |
| `etc/config/boundlesstheme` | File penanda — menu tampil bila file ini ada |
| `install.sh` / `uninstall.sh` | Installer aplikasi (dengan backup + verifikasi) |

## Kredit & lisensi

Syamsul Sarip Hidayat · Boundless. Apache License 2.0 (lihat `LICENSE`).
