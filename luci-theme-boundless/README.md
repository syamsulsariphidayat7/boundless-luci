# luci-theme-boundless

Tema LuCI **full** (semua halaman) untuk OpenWrt 24.10: layout resmi
`luci-theme-material` yang dimodernisasi ke **Material 3 terang**
(terang sejak v5; di v8 seluruh tema — nama paket, folder statis,
registrasi UCI, nama file — diganti total mengikuti varian terang ini,
dan riwayat git ditulis ulang).

- **Referensi:** `luci-theme-material` resmi dari repo `openwrt/luci`
  (`themes/luci-theme-material`) — top bar + sidebar kiri, template
  header/footer, `cascade.css`, dan menu JS-nya dipakai sebagai basis.
- **Modernisasi Material 3:** sudut membulat besar (card / tombol / input
  radius 12–20px, state aktif berbentuk pill), permukaan tonal bertingkat.
- **Palet saat ini (v1.0.0):** background `#F4F6FA`, teks gelap kontras
  tinggi, warna primer datar `#0B486B`, dan **gradien khas** biru baja →
  burgundy `#29445E → #89253E` di header, tombol utama, state aktif,
  progress bar, dan dock bawah (token `--m3-grad-*` di `custom.css`).
- **Komponen Material 3:** switch & radio M3, dialog (radius 28px),
  filled text field, bar aksi melayang, progress bar M3 dengan label
  chip, ripple saat klik, animasi hover (angkat + kilau) di tombol.
- **Sentuhan layout:** header ter-center vertikal presisi dengan logo
  Boundless; bar `#menu` menjadi **dock mengambang** di tengah bawah;
  notifikasi Release RAM tampil sebagai toast di atas dock.
- **Kompatibilitas REYRE-WRT (v6–v7):** footer memuat placeholder
  `<div id="tempcpu">` + `<div id="cpuusage">` (baris Temperature & CPU
  Usage di Status → Overview firmware REYRE-WRT); header memuat baris
  ikon shortcut navbar dan bar menu `#menu` (Modem / Terminal /
  Yacd / About / Clear RAM) yang di-port 1:1 dari tema material
  bawaan firmware itu, lalu di tema ini ditampilkan sebagai dock
  mengambang di bawah. Ikon navbar tidak dibundel; `install.sh`
  menyalin folder `navbar/` dari tema material bawaan bila ada di STB.

> ✅ **Sudah dites di STB asli** — HG680P dengan firmware REYRE-WRT
> (OpenWrt 24.10.8): terpasang, aktif, dan dipakai harian sejak
> 2026-10-28. Untuk perangkat/firmware lain, tetap jaga jalur rollback:
> biarkan tema `bootstrap` terpasang dan pastikan kamu bisa SSH ke STB
> sebelum mengaktifkan tema ini.

---

## Preview tanpa install

Buka salah satu file ini di browser PC/HP kamu:

```
preview-standalone.html   <- disarankan: 1 file, CSS + ikon + logo sudah inline
preview.html              <- versi repo, butuh folder htdocs/ di sebelahnya
```

Preview itu mock halaman *Status → Overview* LuCI (header, sidebar, card,
tabel, form, tombol, alert) yang memakai `cascade.css` **yang sama persis**
dengan yang akan terpasang di STB, jadi tampilannya bisa dinilai dulu.
Catatan: penampil file bawaan sebagian aplikasi tidak memuat CSS eksternal
relatif — kalau `preview.html` tampil polos/rusak, pakai
`preview-standalone.html`.

## Struktur

Struktur di bawah diverifikasi dari source resmi `openwrt/luci`
branch `openwrt-24.10` (dan master — hasilnya sama). **Penting:** tema
resmi versi sekarang **tidak lagi** memakai `luasrc/view/themes/<nama>/*.htm`;
yang dipakai adalah template **ucode** `.ut`.

```
luci-theme-boundless/
├── Makefile                        # pola Makefile tema LuCI resmi (untuk buildroot/feed)
├── README.md
├── LICENSE                         # Apache License 2.0 (sama seperti tema asal)
├── NOTICE                          # atribusi karya turunan dari luci-theme-material
├── preview.html                    # mock statis, pakai cascade.css asli tema ini
├── preview-standalone.html         # versi 1-file dari preview (CSS inline), aman dibuka di mana saja
├── install.sh                      # install manual di STB (POSIX sh / ash)
├── online-install.sh               # install 1 baris dari GitHub (curl/wget) - download + panggil install.sh
├── uninstall.sh                    # rollback ke tema sebelumnya (+ --remove-files)
├── htdocs/luci-static/
│   ├── boundless/
│   │   ├── cascade.css             # basis: cascade.css resmi material + blok override "MATERIAL3 LIGHT"
│   │   ├── custom.css              # nama variabel SAMA seperti resmi, nilainya palet terang M3 (v5)
│   │   ├── logo.svg, logo_48.png, brand.png, icons/   # aset resmi material
│   └── resources/
│       └── menu-boundless.js   # salinan menu-material.js resmi, nama disesuaikan
├── ucode/template/themes/boundless/
│   ├── header.ut                   # DARI header.ut resmi 24.10; beda: nama tema, theme-color, komentar
│   └── footer.ut                   # sama; L.require('menu-boundless')
├── luasrc/view/themes/boundless/
│   ├── header.htm                  # LEGACY - port klasik best-effort, TIDAK dipakai 24.10, tidak diinstall install.sh
│   └── footer.htm                  # LEGACY - idem
└── root/etc/uci-defaults/
    └── 30_luci-theme-boundless  # pola sama seperti 30_luci-theme-material resmi
```

Kenapa CSS-nya begitu? `cascade.css` resmi dibiarkan utuh supaya semua
selector tetap cocok dengan markup yang dihasilkan LuCI. Restyle
Material 3 ditambahkan sebagai satu blok besar di bagian paling akhir file
itu (`MATERIAL3 OVERRIDES`) plus nilai variabel di `custom.css`.

Di STB, file-file di atas terpasang ke:

| Di repo ini | Di STB |
|---|---|
| `htdocs/luci-static/boundless/*` | `/www/luci-static/boundless/` |
| `htdocs/luci-static/resources/menu-boundless.js` | `/www/luci-static/resources/` |
| `ucode/template/themes/boundless/*` | `/usr/share/ucode/luci/template/themes/boundless/` |

## Install dari GitHub pakai curl (satu baris, di STB)

Tema ini tinggal di repo gabungan
[**boundless-luci**](https://github.com/syamsulsariphidayat7/boundless-luci)
(subfolder `luci-theme-boundless`). Syarat: repo itu **sudah di-push ke
GitHub dan Public**. Jalankan via SSH di STB:

```sh
curl -fsSL https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/luci-theme-boundless/online-install.sh | sh
```

OpenWrt bawaan sering **tidak punya curl** (yang ada `wget`) — pakai ini:

```sh
wget -qO- https://raw.githubusercontent.com/syamsulsariphidayat7/boundless-luci/main/luci-theme-boundless/online-install.sh | sh
```

`online-install.sh` mendownload **rilis terbaru** (tag git terakhir
repo boundless-luci) dari GitHub — bukan isi branch yang masih
berubah — mengambil folder tema di dalamnya, menyimpannya ke
`/root/luci-theme-boundless` (supaya `uninstall.sh` tetap bisa
dijalankan untuk rollback), lalu menjalankan `install.sh`.
Selesai → hard refresh LuCI (`Ctrl+F5`).
Tag rilis tertentu bisa dipaksa: `VERSION=1.1.0 sh online-install.sh`
(nomornya adalah versi rilis repo gabungan); untuk keperluan dev ada
juga `BRANCH=main sh online-install.sh`.

Varian tanpa pipe-ke-shell (download tarball manual):

```sh
curl -fsSL https://github.com/syamsulsariphidayat7/boundless-luci/archive/refs/heads/main.tar.gz | tar -xz -C /tmp
cd /tmp/boundless-luci-main/luci-theme-boundless
sh install.sh
```

## Install manual (cara yang disarankan untuk tes pertama)

1. Pastikan rollback aman dulu:
   - Tema `bootstrap` masih terpasang (`opkg list-installed | grep luci-theme` /
     di 24.10 dengan apk: `apk list --installed | grep luci-theme`).
   - Kamu bisa login **SSH** ke STB (jangan cuma mengandalkan web LuCI).
2. Salin folder tema ini ke STB, misal dari laptop:

   ```sh
   scp -r luci-theme-boundless root@192.168.1.1:/tmp/
   ```

   *(Ganti IP dengan IP STB kamu.)*
3. Di STB (via SSH):

   ```sh
   cd /tmp/luci-theme-boundless
   sh install.sh
   ```

   `install.sh` akan: menyalin file, menyimpan tema aktif sebelumnya ke
   `/etc/boundless-previous-theme`, mendaftarkan
   `luci.themes.Boundless`, mengaktifkan
   `luci.main.mediaurlbase=/luci-static/boundless`, membersihkan cache
   LuCI, lalu restart `uhttpd`.
4. Refresh LuCI di browser (hard refresh `Ctrl+F5`).

## Install via package (buildroot / feed)

Taruh folder ini sebagai `themes/luci-theme-boundless` di dalam feed
LuCI (di samping `themes/luci-theme-material`), lalu pilih
`LuCI > Themes > luci-theme-boundless` di `menuconfig` dan build seperti
tema LuCI resmi lainnya — `Makefile`-nya mengikuti pola resmi dan `luci.mk`
akan menyalin `htdocs/`, `ucode/`, `luasrc/`, dan `root/` secara otomatis.

## Mengaktifkan tema (kalau file sudah terpasang)

**Lewat LuCI:** `System → System → Language and Style` → pilih
**Boundless** → Save & Apply.

**Lewat UCI (SSH):**

```sh
uci set luci.main.mediaurlbase='/luci-static/boundless'
uci commit luci
/etc/init.d/uhttpd restart
```

## Cek versi yang terpasang

Versi tema tertanam di file CSS-nya, jadi bisa dicek langsung di STB:

```sh
grep -m1 "Version:" /www/luci-static/boundless/cascade.css
```

## Uninstall / rollback

Dari folder tema ini di STB:

```sh
sh uninstall.sh                 # aktifkan lagi tema sebelumnya, file tema tetap ada
sh uninstall.sh --remove-files  # sekalian hapus file tema dari STB
```

Rollback manual (tanpa script), misal kalau LuCI tidak bisa dibuka —
jalankan via SSH:

```sh
uci set luci.main.mediaurlbase='/luci-static/bootstrap'
uci commit luci
/etc/init.d/uhttpd restart
```

## Catatan untuk perangkat / firmware lain

Tema ini terverifikasi di HG680P + REYRE-WRT (OpenWrt 24.10.8). Di
perangkat atau build lain, yang perlu diperhatikan:

1. **Template ucode** — `header.ut`/`footer.ut` diadaptasi dari tema
   material resmi branch `openwrt-24.10`; build 24.10.x yang beda
   patchlevel bisa sedikit beda. Kalau halaman blank/error, log-nya
   ada di `logread` / output uhttpd — rollback dulu, baru lihat log.
2. **Halaman aplikasi pihak ketiga** yang punya CSS sendiri — tema ini
   menstyle elemen LuCI standar; halaman custom bisa saja menimpa
   sebagian tampilannya sendiri.
3. **Menu di layar kecil / HP** — perilaku sidebar meniru
   `menu-material.js` resmi (toggle `.showSide`, batas 1152px).
4. Baris ikon navbar + dock `#menu` + baris Temperature/CPU Usage
   adalah kekhususan firmware REYRE-WRT; di firmware lain bagian itu
   tidak muncul / tidak terpakai, tema tetap berfungsi normal.

## Kredit & lisensi

Derivasi dari **luci-theme-material** — Copyright 2015–2017 Lutty Yang,
berbasis luci-theme-bootstrap & MUI. Lisensi **Apache License 2.0**, sama
seperti tema aslinya. Aset gambar (`logo.svg`, `brand.png`, ikon) adalah
milik tema aslinya.
