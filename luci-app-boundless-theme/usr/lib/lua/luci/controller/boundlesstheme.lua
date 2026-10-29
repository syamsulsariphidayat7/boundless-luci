module("luci.controller.boundlesstheme", package.seeall)

-- luci-app-boundless-theme: panel kelola tema luci-theme-boundless.
-- Dashboard ini kulit tipis di atas script tema yang sudah ada.
-- Sumber tunggalnya adalah repo gabungan "boundless-luci" (tema ada di
-- subfolder luci-theme-boundless):
--   Install/Update -> unduh tarball rilis repo itu, jalankan install.sh
--                     tema dari subfoldernya
--   Rollback/Hapus -> uninstall.sh tema (dengan fallback inline bila
--   unduhan gagal, supaya tetap bisa jalan offline).
-- Pola (detached + log/rc/pid di /tmp + polling) mengikuti hg680pcls.

function index()
	if not nixio.fs.access("/etc/config/boundlesstheme") then
		return
	end
	entry({"admin", "system", "boundlesstheme"},
		template("boundlesstheme/dashboard"), "Boundless Theme", 90)
	entry({"admin", "system", "boundlesstheme", "status"},
		call("action_status")).leaf = true
	entry({"admin", "system", "boundlesstheme", "check"},
		call("action_check")).leaf = true
	entry({"admin", "system", "boundlesstheme", "update"},
		post("action_update")).leaf = true
	entry({"admin", "system", "boundlesstheme", "updatelog"},
		call("action_updatelog")).leaf = true
	entry({"admin", "system", "boundlesstheme", "manage"},
		post("action_manage")).leaf = true
	entry({"admin", "system", "boundlesstheme", "managelog"},
		call("action_managelog")).leaf = true
	entry({"admin", "system", "boundlesstheme", "activate"},
		post("action_activate")).leaf = true
	entry({"admin", "system", "boundlesstheme", "scheme"},
		post("action_scheme")).leaf = true
end

local BUNDLE_SLUG = "syamsulsariphidayat7/boundless-luci"
local REPO_RAW   = "https://raw.githubusercontent.com/" .. BUNDLE_SLUG
local REPO_API   = "https://api.github.com/repos/" .. BUNDLE_SLUG
local THEME_SUB  = "luci-theme-boundless"

local CASCADE    = "/www/luci-static/boundless/cascade.css"
local SCHEME_CSS = "/www/luci-static/boundless/scheme.css"
local PREV_FILE  = "/etc/boundless-previous-theme"
local INSTALLER_DIR = "/root/luci-theme-boundless"
local APP_VERSION_FILE = "/usr/lib/lua/luci/view/boundlesstheme/VERSION"

-- Wajib POST + token CSRF yang sah (sama seperti hg680pcls).
local function require_post()
	local disp = luci.dispatcher
	if disp and disp.test_post_security then
		return disp.test_post_security()
	end
	if luci.http.getenv("REQUEST_METHOD") ~= "POST" then
		luci.http.status(405, "Method Not Allowed")
		return false
	end
	local tok  = luci.http.formvalue("token")
	local want = disp and disp.context and disp.context.authtoken
	if tok and want and tok == want then
		return true
	end
	luci.http.status(403, "Forbidden")
	return false
end

local function read_file(path)
	local f = io.open(path, "r")
	if not f then return nil end
	local data = f:read("*a")
	f:close()
	return data
end

local function read_head(path, max)
	local f = io.open(path, "r")
	if not f then return nil end
	local data = f:read(max)
	f:close()
	return data
end

local function read_tail(path, max)
	local f = io.open(path, "rb")
	if not f then return "" end
	local size = f:seek("end") or 0
	local off = size - max
	if off < 0 then off = 0 end
	f:seek("set", off)
	local data = f:read("*a") or ""
	f:close()
	return data
end

local function read_trim(path)
	local s = read_file(path)
	if not s then return nil end
	s = s:gsub("%s+", "")
	if s == "" then return nil end
	return s
end

-- Ambil teks dari URL: curl bila ada, kalau tidak wget.
local function fetch_text(url)
	local out = luci.sys.exec(string.format(
		"if command -v curl >/dev/null 2>&1; then curl -fsSL --connect-timeout 6 --max-time 15 %s; "
		.. "elif command -v wget >/dev/null 2>&1; then wget -qO- --timeout=15 %s; fi 2>/dev/null",
		luci.util.shellquote(url), luci.util.shellquote(url)))
	return out or ""
end

local function fetch_file(url, dest)
	return luci.sys.call(string.format(
		"if command -v curl >/dev/null 2>&1; then curl -fsSL --connect-timeout 8 --max-time 60 %s -o %s; "
		.. "elif command -v wget >/dev/null 2>&1; then wget -q --timeout=60 %s -O %s; "
		.. "else exit 127; fi 2>/dev/null",
		luci.util.shellquote(url), luci.util.shellquote(dest),
		luci.util.shellquote(url), luci.util.shellquote(dest))) == 0
end

local function app_version()
	local v = read_file(APP_VERSION_FILE)
	if not v then return "?" end
	v = v:gsub("%s+", "")
	if v == "" then return "?" end
	return v
end

-- Daftar tema terdaftar di luci.themes (nama -> path mediaurlbase).
local function theme_list()
	local uci = luci.model.uci.cursor()
	local sec = uci:get_all("luci", "themes") or {}
	local out = {}
	for k, v in pairs(sec) do
		if type(k) == "string" and k:sub(1, 1) ~= "." and type(v) == "string" then
			out[#out + 1] = { name = k, path = v }
		end
	end
	table.sort(out, function(a, b) return a.name < b.name end)
	return out
end

-- Keadaan tema di perangkat ini.
local function theme_state()
	local installed = nixio.fs.access(CASCADE) ~= nil
	local version = nil
	if installed then
		local head = read_head(CASCADE, 3000) or ""
		version = head:match("Version:%s*([0-9][0-9%.%-]*)")
	end
	local uci = luci.model.uci.cursor()
	local base = uci:get("luci", "main", "mediaurlbase") or ""
	return {
		installed = installed,
		version = version,
		active = base == "/luci-static/boundless",
		mediaurlbase = base,
		has_installer = nixio.fs.access(INSTALLER_DIR .. "/uninstall.sh") ~= nil,
	}
end

-- ================= Skema warna =================
-- Skema yang LULUS saring Syamsul (2026-10-29, dari sample 6 skema
-- historis tema): varian gelap Love Couple + Pun Yeta. Atas
-- permintaan Syamsul nama tampilnya TANPA kata "Gelap" ("Love Couple
-- (bawaan)" + "Pun Yeta"); yang dicoret waktu itu adalah versi
-- terangnya (Biru M3, Pun Yeta asli, Aqua Marine, Love Couple asli) -
-- hex-nya tersimpan di sample-skema.png (workspace/your_files/schemes).
-- Ditambah 3 skema uiGradients pilihan Syamsul (2026-10-29):
-- Sand to Blue, Purplepine, Deep Space. Untuk ketiganya, stop ketiga
-- (progress) = warna kedua diterangkan 35% ke putih, primer = warna
-- pertama digelapkan 20% (pola turunan yang sama seperti skema lama).
-- Pilihan disimpan di UCI (boundlesstheme.settings.scheme) dan diterapkan dengan menulis ulang scheme.css di folder
-- statis tema - file itu di-@import cascade.css SETELAH custom.css,
-- jadi override-nya menang di spesifisitas yang sama. "bawaan" =
-- tanpa override (nilai token asli di custom.css). Skema disimpan
-- di perangkat, jadi berlaku untuk semua browser, dan install.sh
-- tema menjaga file scheme.css tetap ada saat install ulang.
local SCHEMES = {
	{ id = "bawaan",         name = "Love Couple (bawaan)",
	  c1 = "#29445e", c2 = "#89253e", third = "#b67887", primary = "#0b486b" },
	{ id = "pun-yeta",       name = "Pun Yeta",
	  c1 = "#0b486b", c2 = "#ef8e38", third = "#f5b877", primary = "#0b486b" },
	{ id = "sand-to-blue",   name = "Sand to Blue",
	  c1 = "#3e5151", c2 = "#decba4", third = "#eaddc4", primary = "#324141" },
	{ id = "purplepine",     name = "Purplepine",
	  c1 = "#20002c", c2 = "#cbb4d4", third = "#ddcee3", primary = "#1a0023" },
	{ id = "deep-space",     name = "Deep Space",
	  c1 = "#000000", c2 = "#434343", third = "#858585", primary = "#000000" },
}

local function scheme_by_id(id)
	for _, s in ipairs(SCHEMES) do
		if s.id == id then return s end
	end
	return nil
end

local function current_scheme()
	local uci = luci.model.uci.cursor()
	local id = uci:get("boundlesstheme", "settings", "scheme")
	if id and scheme_by_id(id) then return id end
	return "bawaan"
end

local function write_scheme_css(s)
	local f = io.open(SCHEME_CSS, "w")
	if not f then return false end
	if s.id == "bawaan" then
		f:write("/* Skema bawaan (Love Couple): tanpa override - nilai token asli custom.css yang berlaku. */\n")
	else
		f:write(string.format(
			"/* Skema aktif: %s - ditulis dashboard Boundless Theme; jangan diedit manual. */\n"
			.. ":root {\n"
			.. "\t--m3-primary: %s;\n"
			.. "\t--m3-grad-header: linear-gradient(90deg, %s 0%%, %s 100%%);\n"
			.. "\t--m3-grad-accent: linear-gradient(135deg, %s 0%%, %s 100%%);\n"
			.. "\t--m3-grad-primary: linear-gradient(135deg, %s 0%%, %s 100%%);\n"
			.. "\t--m3-grad-progress: linear-gradient(90deg, %s 0%%, %s 55%%, %s 100%%);\n"
			.. "}\n"
			.. "#menu { background-color: %s !important; }\n",
			s.name, s.primary,
			s.c1, s.c2, s.c1, s.c2, s.c1, s.c2,
			s.c1, s.c2, s.third, s.c1))
	end
	f:close()
	return true
end

-- Ref rilis terbaru repo gabungan = tag v<versi> tertinggi; fallback
-- ke branch main bila belum ada tag / API tidak terjangkau.
local function latest_ref()
	local out = fetch_text(REPO_API .. "/tags?per_page=100")
	local best, bestnum
	for v in out:gmatch('"name"%s*:%s*"v([0-9][0-9%.%-]*)"') do
		local a, b, c = v:match("^(%d+)%.(%d+)%.(%d+)")
		if a then
			local num = tonumber(a) * 1000000 + tonumber(b) * 1000 + tonumber(c)
			if not bestnum or num > bestnum then
				bestnum, best = num, v
			end
		end
	end
	if best then
		return "v" .. best
	end
	return "main"
end

-- Versi tema terbaru: baca file VERSION tema pada ref rilis terbaru.
-- Sejak proyek digabung, versi komponen SAMA dengan versi bundle
-- (satu nomor untuk tema + dashboard), dan tag rilis memuat angka
-- yang sama; membaca dari file tetap cara paling pasti.
local function remote_version()
	local ref = latest_ref()
	local v = fetch_text(REPO_RAW .. "/" .. ref .. "/" .. THEME_SUB .. "/VERSION")
	return (v or ""):gsub("%s+", ""), ref
end

-- Catatan rilis dari CHANGELOG.md tema untuk versi tsb.
local function changelog_notes(ver, ref)
	if not ver or ver == "" or not ref then return "" end
	local txt = fetch_text(REPO_RAW .. "/" .. ref .. "/" .. THEME_SUB .. "/CHANGELOG.md")
	if not txt or txt == "" then return "" end
	local out, on = {}, false
	for line in (txt .. "\n"):gmatch("([^\n]*)\n") do
		if line:match("^##%s") then
			if on then break end
			local v = line:gsub("^##%s*", ""):gsub("[%[%]]", ""):match("^([%w%.%-]+)")
			if v == ver then on = true end
		elseif on and line:match("%S") then
			out[#out + 1] = line
		end
	end
	local s = table.concat(out, "\n")
	if #s > 900 then s = s:sub(1, 900) .. "\n..." end
	return s
end

-- ================= Mesin proses latar (detached) =================

local function chan_paths(name)
	return {
		log = "/tmp/boundlesstheme-" .. name .. ".log",
		rc  = "/tmp/boundlesstheme-" .. name .. ".rc",
		pid = "/tmp/boundlesstheme-" .. name .. ".pid",
	}
end

local function chan_running(p)
	if read_trim(p.rc) then return false end
	local pid = read_trim(p.pid)
	if pid and pid:match("^%d+$") and nixio.fs.access("/proc/" .. pid) then
		return true
	end
	return false
end

local function detach_prefix()
	if luci.sys.call("command -v setsid >/dev/null 2>&1") == 0 then
		return "setsid "
	end
	return ""
end

-- Jalankan body shell secara detached; wrapper menulis pid + rc sendiri.
local function chan_start(p, body)
	luci.sys.call(string.format("rm -f %s %s %s", p.log, p.rc, p.pid))
	local wrapper = string.format("echo $$ > %s\n%s\necho $? > %s\nrm -f %s",
		p.pid, body, p.rc, p.pid)
	luci.sys.call(string.format("%ssh -c %s </dev/null >%s 2>&1 &",
		detach_prefix(), luci.util.shellquote(wrapper), p.log))
end

local function chan_report(p)
	local rc = read_trim(p.rc)
	local code
	if rc and rc:match("^%d+$") then code = tonumber(rc) end
	return {
		ok = true,
		running = chan_running(p),
		done = rc ~= nil,
		code = code,
		log = read_tail(p.log, 4000),
	}
end

local UPDATE = chan_paths("update")
local MANAGE = chan_paths("manage")
local DL_SCRIPT = "/tmp/boundlesstheme-online.sh"

-- ================= Endpoint =================

function action_status()
	local st = theme_state()
	local schemes = {}
	for _, s in ipairs(SCHEMES) do
		schemes[#schemes + 1] = { id = s.id, name = s.name, c1 = s.c1, c2 = s.c2 }
	end
	luci.http.prepare_content("application/json")
	luci.http.write(luci.jsonc.stringify({
		ok = true,
		installed = st.installed,
		version = st.version,
		active = st.active,
		mediaurlbase = st.mediaurlbase,
		has_installer = st.has_installer,
		app_version = app_version(),
		themes = theme_list(),
		scheme = current_scheme(),
		schemes = schemes,
	}))
end

-- POST /activate — ganti tema aktif (tulis luci.main.mediaurlbase, sama
-- seperti dropdown Design di System -> Language and Style). Nilai yang
-- diterima HANYA path yang memang terdaftar di luci.themes.
function action_activate()
	if not require_post() then return end
	local http = luci.http
	http.prepare_content("application/json")
	local want = http.formvalue("theme") or ""
	local valid = false
	for _, t in ipairs(theme_list()) do
		if t.path == want then valid = true break end
	end
	if not valid then
		http.status(400, "Bad Request")
		return http.write(luci.jsonc.stringify({ ok = false, error = "tema tidak terdaftar" }))
	end
	local uci = luci.model.uci.cursor()
	uci:set("luci", "main", "mediaurlbase", want)
	uci:commit("luci")
	-- Restart uhttpd belakangan (respons terkirim dulu) supaya tidak ada
	-- keadaan cache tema yang basi.
	luci.sys.call("( sleep 1; /etc/init.d/uhttpd restart ) </dev/null >/dev/null 2>&1 &")
	http.write(luci.jsonc.stringify({ ok = true, active = want }))
end

-- POST /scheme — simpan skema warna pilihan ke UCI + tulis scheme.css.
-- Aksi sinkron dan cepat (tanpa proses latar): file CSS statis, jadi
-- halaman LuCI berikutnya langsung memakai skema baru; halaman yang
-- sudah terbuka perlu hard refresh karena cache CSS browser.
function action_scheme()
	if not require_post() then return end
	local http = luci.http
	http.prepare_content("application/json")
	local s = scheme_by_id(http.formvalue("scheme") or "")
	if not s then
		http.status(400, "Bad Request")
		return http.write(luci.jsonc.stringify({ ok = false, error = "skema tidak dikenal" }))
	end
	local uci = luci.model.uci.cursor()
	if not uci:get_first("boundlesstheme", "settings") then
		uci:section("boundlesstheme", "settings", "settings")
	end
	uci:set("boundlesstheme", "settings", "scheme", s.id)
	uci:commit("boundlesstheme")
	if not write_scheme_css(s) then
		http.status(500, "Internal Server Error")
		return http.write(luci.jsonc.stringify({ ok = false, error = "gagal menulis scheme.css - tema belum terpasang?" }))
	end
	http.write(luci.jsonc.stringify({ ok = true, scheme = s.id }))
end

function action_check()
	local st = theme_state()
	local lv = st.version or ""
	local rv, ref = remote_version()
	local has_update = (rv ~= "" and rv ~= lv)
	luci.http.prepare_content("application/json")
	luci.http.write(luci.jsonc.stringify({
		ok = true,
		["local"] = lv,
		remote = rv,
		update = has_update,
		notes = has_update and changelog_notes(rv, ref) or "",
	}))
end

function action_update()
	if not require_post() then return end
	local http = luci.http
	http.prepare_content("application/json")
	if chan_running(UPDATE) then
		http.status(409, "Conflict")
		return http.write(luci.jsonc.stringify({ ok = false, error = "pemasangan sedang berjalan" }))
	end
	if chan_running(MANAGE) then
		http.status(409, "Conflict")
		return http.write(luci.jsonc.stringify({ ok = false, error = "pengelolaan sedang berjalan" }))
	end
	local _, ref = remote_version()
	if not ref or ref == "" then ref = "main" end
	-- Unduh tarball repo gabungan pada ref rilis, ambil subfolder tema,
	-- simpan ke /root/luci-theme-boundless, jalankan install.sh dari
	-- sana (detached). Baris terakhir menentukan exit code wrapper:
	-- kegagalan diakhiri `false`, BUKAN `exit`, supaya rc tetap ditulis.
	local tarball
	if ref == "main" then
		tarball = "https://github.com/" .. BUNDLE_SLUG .. "/archive/refs/heads/main.tar.gz"
	else
		tarball = "https://github.com/" .. BUNDLE_SLUG .. "/archive/refs/tags/" .. ref .. ".tar.gz"
	end
	local body = string.format([[
TMPD=/tmp/boundlesstheme-bundle
rm -rf "$TMPD"
mkdir -p "$TMPD"
if curl -fsSL --connect-timeout 10 --max-time 120 %s -o "$TMPD/b.tar.gz" 2>/dev/null || wget -q --timeout=120 %s -O "$TMPD/b.tar.gz" 2>/dev/null; then
    tar -xzf "$TMPD/b.tar.gz" -C "$TMPD"
    SRC=$(find "$TMPD" -maxdepth 3 -type d -name luci-theme-boundless | head -1)
    if [ -n "$SRC" ] && [ -f "$SRC/install.sh" ]; then
        rm -rf /root/luci-theme-boundless
        cp -r "$SRC" /root/luci-theme-boundless
        rm -rf "$TMPD"
        cd /root/luci-theme-boundless && sh install.sh
    else
        echo "[boundless] Folder tema tidak ditemukan di dalam paket boundless-luci"
        false
    fi
else
    echo "[boundless] Gagal mengunduh paket boundless-luci dari GitHub"
    false
fi]],
		luci.util.shellquote(tarball), luci.util.shellquote(tarball))
	chan_start(UPDATE, body)
	http.write(luci.jsonc.stringify({ ok = true, started = true, ref = ref }))
end

function action_updatelog()
	local r = chan_report(UPDATE)
	local st = theme_state()
	r["local"] = st.version
	r.installed = st.installed
	luci.http.prepare_content("application/json")
	luci.http.write(luci.jsonc.stringify(r))
end

-- action=rollback -> uninstall.sh tema tanpa argumen (tema sebelumnya
-- diaktifkan lagi, file Boundless tetap ada).
-- action=remove   -> uninstall.sh --remove-files (file ikut dihapus).
-- Bila unduhan uninstall.sh gagal (offline), fallback inline melakukan
-- hal yang setara supaya tombol tetap berfungsi.
function action_manage()
	if not require_post() then return end
	local http = luci.http
	http.prepare_content("application/json")
	local action = http.formvalue("action")
	if action ~= "rollback" and action ~= "remove" then
		http.status(400, "Bad Request")
		return http.write(luci.jsonc.stringify({ ok = false, error = "action tidak valid" }))
	end
	if chan_running(UPDATE) then
		http.status(409, "Conflict")
		return http.write(luci.jsonc.stringify({ ok = false, error = "pemasangan sedang berjalan" }))
	end
	if chan_running(MANAGE) then
		http.status(409, "Conflict")
		return http.write(luci.jsonc.stringify({ ok = false, error = "pengelolaan sedang berjalan" }))
	end
	local _, ref = remote_version()
	if not ref or ref == "" then ref = "main" end

	local args = (action == "remove") and " --remove-files" or ""
	local fallback
	if action == "rollback" then
		fallback = [[
PREV=$(cat /etc/boundless-previous-theme 2>/dev/null || echo "/luci-static/material")
[ "$PREV" = "/luci-static/boundless" ] && PREV="/luci-static/material"
echo "[boundless] (fallback) Mengembalikan tema aktif ke: $PREV"
uci set luci.main.mediaurlbase="$PREV"
uci -q delete luci.themes.Boundless
uci commit luci
rm -rf /tmp/luci-modulecache /tmp/luci-indexcache
/etc/init.d/uhttpd restart]]
	else
		fallback = [[
echo "[boundless] (fallback) Menghapus tema Boundless"
uci set luci.main.mediaurlbase='/luci-static/material'
uci -q delete luci.themes.Boundless
uci commit luci
rm -rf /www/luci-static/boundless /usr/share/ucode/luci/template/themes/boundless
rm -f /www/luci-static/resources/menu-boundless.js /etc/boundless-previous-theme
rm -rf /tmp/luci-modulecache /tmp/luci-indexcache
/etc/init.d/uhttpd restart]]
	end

	-- sleep 1: respons JSON ini terkirim dulu sebelum uhttpd restart.
	local body = string.format([[
sleep 1
if curl -fsSL --connect-timeout 10 --max-time 60 %s -o %s 2>/dev/null || wget -q --timeout=60 %s -O %s 2>/dev/null; then
    sh %s%s
else
    echo "[boundless] Gagal mengunduh uninstall.sh; memakai fallback lokal"
%s
fi]],
		luci.util.shellquote(REPO_RAW .. "/" .. ref .. "/" .. THEME_SUB .. "/uninstall.sh"),
		luci.util.shellquote(DL_SCRIPT),
		luci.util.shellquote(REPO_RAW .. "/" .. ref .. "/" .. THEME_SUB .. "/uninstall.sh"),
		luci.util.shellquote(DL_SCRIPT),
		luci.util.shellquote(DL_SCRIPT), args,
		fallback)
	chan_start(MANAGE, body)
	http.write(luci.jsonc.stringify({ ok = true, started = true, action = action, ref = ref }))
end

function action_managelog()
	local r = chan_report(MANAGE)
	luci.http.prepare_content("application/json")
	luci.http.write(luci.jsonc.stringify(r))
end
