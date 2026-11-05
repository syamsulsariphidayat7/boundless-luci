/* Boundless dock renderer (2.2.0) - menggambar item dock bawah
   dari window.BOUNDLESS_DOCK_ITEMS (dock-data.js, ditulis
   dashboard Boundless Theme dari konfigurasi UCI). Bila data
   itu tidak ada (aplikasi pengelola belum terpasang / belum
   pernah membuka dashboard), dipakai daftar bawaan di bawah -
   sama persis dengan dock hardcoded sampai 2.1.6.
   {host} di href diganti hostname yang sedang dipakai browser.
   Penanda item aktif TIDAK di sini: script lama di header
   yang berjalan sesudah file ini yang menanganinya.
   Posisi dock (2.3.0): window.BOUNDLESS_DOCK_POS = "right"
   memasang kelas dock-right di #menu dan body; gayanya di
   cascade.css. Tanpa data itu, posisinya bawah (bawaan). */
(function () {
	"use strict";
	var FALLBACK = [
		{ label: "Modem", href: "http://192.168.8.1/", icon: "M200-120q-33 0-56.5-23.5T120-200v-160q0-33 23.5-56.5T200-440h400v-160h80v160h80q33 0 56.5 23.5T840-360v160q0 33-23.5 56.5T760-120H200Zm0-80h560v-160H200v160Zm80-40q17 0 28.5-11.5T320-280q0-17-11.5-28.5T280-320q-17 0-28.5 11.5T240-280q0 17 11.5 28.5T280-240Zm140 0q17 0 28.5-11.5T460-280q0-17-11.5-28.5T420-320q-17 0-28.5 11.5T380-280q0 17 11.5 28.5T420-240Zm140 0q17 0 28.5-11.5T600-280q0-17-11.5-28.5T560-320q-17 0-28.5 11.5T520-280q0 17 11.5 28.5T560-240Zm10-390-58-58q26-24 58-38t70-14q38 0 70 14t58 38l-58 58q-14-14-31.5-22t-38.5-8q-21 0-38.5 8T570-630ZM470-730l-56-56q44-44 102-69t124-25q66 0 124 25t102 69l-56 56q-33-33-76.5-51.5T640-800q-50 0-93.5 18.5T470-730ZM200-200v-160 160Z", color: "#38bdf8", external: true, enabled: true },
		{ label: "Terminal", href: "/cgi-bin/luci/admin/services/ttyd", icon: "M160-160q-33 0-56.5-23.5T80-240v-480q0-33 23.5-56.5T160-800h640q33 0 56.5 23.5T880-720v480q0 33-23.5 56.5T800-160H160Zm0-80h640v-400H160v400Zm140-40-56-56 103-104-104-104 57-56 160 160-160 160Zm180 0v-80h240v80H480Z", color: "#4ade80", external: false, enabled: true },
		{ label: "Zsb", href: "http://{host}:9090/ui/zsb", icon: "M520-600v-240h320v240H520ZM120-440v-400h320v400H120Zm400 320v-400h320v400H520Zm-400 0v-240h320v240H120Zm80-400h160v-240H200v240Zm400 320h160v-240H600v240Zm0-480h160v-80H600v80ZM200-200h160v-80H200v80Zm160-320Zm240-160Zm0 240ZM360-280Z", color: "#a78bfa", external: true, enabled: true },
		{ label: "Clear", href: "/cgi-bin/luci/admin/status/release_ram", icon: "M360-360v-240h240v240H360Zm80-80h80v-80h-80v80Zm-80 320v-80h-80q-33 0-56.5-23.5T200-280v-80h-80v-80h80v-80h-80v-80h80v-80q0-33 23.5-56.5T280-760h80v-80h80v80h80v-80h80v80h80q33 0 56.5 23.5T760-680v80h80v80h-80v80h80v80h-80v80q0 33-23.5 56.5T680-200h-80v80h-80v-80h-80v80h-80Zm320-160v-400H280v400h400ZM480-480Z", color: "#22d3ee", external: false, enabled: true },
		{ label: "Sunset", href: "/cgi-bin/luci/admin/services/sunset", icon: "m734-556-56-58 86-84 56 56-86 86ZM80-160v-80h800v80H80Zm360-520v-120h80v120h-80ZM226-558l-84-86 56-56 86 86-58 56Zm71 158h366q-23-54-72-87t-111-33q-62 0-111 33t-72 87Zm-97 80q0-117 81.5-198.5T480-600q117 0 198.5 81.5T760-320H200Zm280-80Z", color: "#fb923c", external: false, enabled: true },
		{ label: "Sinyal", href: "/cgi-bin/luci/admin/modem/3ginfo-lite", icon: "M200-160v-240h120v240H200Zm240 0v-440h120v440H440Zm240 0v-640h120v640H680Z", color: "#a3e635", external: false, enabled: true },
		{ label: "SMS", href: "/cgi-bin/luci/admin/modem/5gmodem/readsms", icon: "M320-520q17 0 28.5-11.5T360-560q0-17-11.5-28.5T320-600q-17 0-28.5 11.5T280-560q0 17 11.5 28.5T320-520Zm160 0q17 0 28.5-11.5T520-560q0-17-11.5-28.5T480-600q-17 0-28.5 11.5T440-560q0 17 11.5 28.5T480-520Zm160 0q17 0 28.5-11.5T680-560q0-17-11.5-28.5T640-600q-17 0-28.5 11.5T600-560q0 17 11.5 28.5T640-520ZM80-80v-720q0-33 23.5-56.5T160-880h640q33 0 56.5 23.5T880-800v480q0 33-23.5 56.5T800-240H240L80-80Zm126-240h594v-480H160v525l46-45Zm-46 0v-480 480Z", color: "#f472b6", external: false, enabled: true },
		{ label: "Tools", href: "/cgi-bin/luci/admin/services/boundlesstools", icon: "M686-132 444-376q-20 8-40.5 12t-43.5 4q-100 0-170-70t-70-170q0-36 10-68.5t28-61.5l146 146 72-72-146-146q29-18 61.5-28t68.5-10q100 0 170 70t70 170q0 23-4 43.5T584-516l244 242q12 12 12 29t-12 29l-84 84q-12 12-29 12t-29-12Zm29-85 27-27-256-256q18-20 26-46.5t8-53.5q0-60-38.5-104.5T386-758l74 74q12 12 12 28t-12 28L332-500q-12 12-28 12t-28-12l-74-74q9 57 53.5 95.5T360-440q26 0 52-8t47-25l256 256ZM472-488Z", color: "#facc15", external: false, enabled: true },
		{ label: "Tema", href: "/cgi-bin/luci/admin/system/boundlesstheme", icon: "M480-80q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 32.5-156t88-127Q256-817 330-848.5T488-880q80 0 151 27.5t124.5 76q53.5 48.5 85 115T880-518q0 115-70 176.5T640-280h-74q-9 0-12.5 5t-3.5 11q0 12 15 34.5t15 51.5q0 50-27.5 74T480-80Zm0-400Zm-220 40q26 0 43-17t17-43q0-26-17-43t-43-17q-26 0-43 17t-17 43q0 26 17 43t43 17Zm120-160q26 0 43-17t17-43q0-26-17-43t-43-17q-26 0-43 17t-17 43q0 26 17 43t43 17Zm200 0q26 0 43-17t17-43q0-26-17-43t-43-17q-26 0-43 17t-17 43q0 26 17 43t43 17Zm120 160q26 0 43-17t17-43q0-26-17-43t-43-17q-26 0-43 17t-17 43q0 26 17 43t43 17ZM480-160q9 0 14.5-5t5.5-13q0-14-15-33t-15-57q0-42 29-67t71-25h70q66 0 113-38.5T800-518q0-121-92.5-201.5T488-800q-136 0-232 93t-96 227q0 133 93.5 226.5T480-160Z", color: "#e879f9", external: false, enabled: true },
	];
	var items = (window.BOUNDLESS_DOCK_ITEMS && window.BOUNDLESS_DOCK_ITEMS.length)
		? window.BOUNDLESS_DOCK_ITEMS : FALLBACK;
	var ul = document.querySelector("#menu ul");
	if (!ul) return;
	if (window.BOUNDLESS_DOCK_POS === "right") {
		var menu = document.querySelector("#menu");
		if (menu) menu.classList.add("dock-right");
		if (document.body) document.body.classList.add("dock-right");
	}
	var SVGNS = "http://www.w3.org/2000/svg";
	items.forEach(function (it) {
		if (!it || it.enabled === false) return;
		var li = document.createElement("li");
		var a = document.createElement("a");
		a.setAttribute("href", String(it.href || "#").replace("{host}", window.location.hostname));
		if (it.external) a.setAttribute("target", "_blank");
		var svg = document.createElementNS(SVGNS, "svg");
		svg.setAttribute("class", "bicon");
		svg.setAttribute("viewBox", "0 -960 960 960");
		svg.setAttribute("aria-hidden", "true");
		if (it.color) svg.style.color = it.color;
		var path = document.createElementNS(SVGNS, "path");
		path.setAttribute("d", it.icon || "");
		svg.appendChild(path);
		a.appendChild(svg);
		a.appendChild(document.createTextNode(it.label || ""));
		li.appendChild(a);
		ul.appendChild(li);
	});
})();
