# Boundless LuCI

Satu proyek, satu versi: **tema LuCI Boundless + dashboard
pengelolanya**, dibundel dalam satu repo untuk OpenWrt 24.10.

| Folder / file | Isi |
| --- | --- |
| `luci-theme-boundless/` | **Tema** LuCI Material 3 terang “Boundless” |
| `luci-app-boundless-theme/` | **Dashboard pengelola** tema (System → Boundless Theme): status, cek update, install/update, ganti tema, rollback, hapus |
| `online-install.sh` | Pasang dua-duanya: satu baris curl/wget dari GitHub, mengunduh rilis terbaru repo ini |
| `online-uninstall.sh` | Copot dua-duanya: satu baris curl/wget — tema diganti ke bawaan, lalu file tema + dashboard dibersihkan |

Tema dan dashboard adalah dua paket LuCI yang berdiri sendiri
(tema ≠ aplikasi, mengikuti pola LuCI) — tapi dikembangkan, diberi
versi, dan dirilis sebagai **satu proyek**: satu nomor versi untuk
keduanya, diambil dari tag rilis repo ini.

Terpasang dan terverifikasi di STB HG680P dengan firmware REYRE-WRT
(OpenWrt 24.10.8).

## Pasang

Satu baris — via SSH di STB (repo ini harus sudah di-push & Public):

```sh
curl -fsSL https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/online-install.sh | sh
```

Kalau STB tidak punya curl (bawaan OpenWrt biasanya hanya wget):

```sh
wget -qO- https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/online-install.sh | sh
```

Selesai → buka LuCI (hard refresh `Ctrl+F5`); kelola tema dari
**System → Boundless Theme** — dari sana tema bisa dicek updatenya,
diperbarui, diganti, di-rollback, atau dihapus.

Tanpa internet di STB pun tetap bisa: unduh repo ini di PC, kirim
folder `luci-theme-boundless` dan `luci-app-boundless-theme` ke STB
pakai scp, lalu jalankan `install.sh` di masing-masing folder.

## Copot

Satu baris — via SSH di STB:

```sh
curl -fsSL https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/online-uninstall.sh | sh
```

(varian wget: ganti perintahnya dengan
`wget -qO- https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/online-uninstall.sh | sh`)

## Kredit & lisensi

Syamsul Sarip Hidayat · Boundless. Apache License 2.0.
