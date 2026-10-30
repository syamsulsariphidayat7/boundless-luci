#
# luci-theme-boundless - Material 3 (light) derivative of luci-theme-material
# Version: 2.1.1 (see VERSION file; component of the boundless-luci bundle)
# Based on luci-theme-material, Copyright 2015-2017 Lutty Yang <lutty@wcan.in>
# Licensed under the Apache License, Version 2.0
#
include $(TOPDIR)/rules.mk

LUCI_TITLE:=Boundless Theme
LUCI_DEPENDS:=+luci-base

PKG_LICENSE:=Apache-2.0

define Package/luci-theme-boundless/postrm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	uci -q delete luci.themes.Boundless
	uci commit luci
}
endef

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
