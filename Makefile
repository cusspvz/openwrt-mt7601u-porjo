#
# Copyright (C) 2007-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7601u-porjo
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/porjo/mt7601.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=e09a91af0270a659d7e50f945d14c9754361e0f4
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz

PKG_BUILD_PARALLEL:=1

PKG_USE_MIPS16:=0

PKG_MAINTAINER:=José Moreira <josemoreiravarzim@gmail.com>

include $(INCLUDE_DIR)/package.mk

WMENU:=Wireless Drivers

define KernelPackage/mt7601u-porjo
	SUBMENU:=Wireless Drivers
	TITLE:=Driver for MT7601U wireless adapters
	FILES:=$(PKG_BUILD_DIR)/os/linux/mt7601Usta.$(LINUX_KMOD_SUFFIX)
	DEPENDS:=+wireless-tools +hostapd-common-old @USB_SUPPORT
	AUTOLOAD:=$(call AutoProbe,mt7601Usta)
	MENU:=1
endef

define KernelPackage/mt7601u-porjo/config
  if PACKAGE_kmod-mt7601u-porjo
  
	config PACKAGE_MT7601U_PORJO_DEBUG
		bool "Enable debug messages"
		default n
		help
		  With this option the driver will emit A LOT
		  of debugging information. 
		  The driver is quite noisy, so enable it only if
		  absolutely necessary to debug problems with this
		  driver.
		  
  endif
endef

define KernelPackage/mt7601u-porjo/description
  This package contains a driver for usb wireless adapters based on the mediatek MT7601U based on porjo patches
endef

ifneq ($(CONFIG_BIG_ENDIAN),)
  ENDIANOPTS:=-DRT_BIG_ENDIAN
else
  ENDIANOPTS:=
endif

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/src LINUX_DIR=$(LINUX_DIR) KERNEL_CROSS=$(KERNEL_CROSS) ARCH=$(LINUX_KARCH) ENDIANOPTS=$(ENDIANOPTS) RTDEBUG=$(PACKAGE_MT7601U_PORJO_DEBUG)
endef

define KernelPackage/mt7601u-porjo/install
	$(INSTALL_DIR) $(1)/etc/Wireless/RT2870STA/
	$(INSTALL_DIR) $(1)/lib/modules/$(LINUX_VERSION)
	$(INSTALL_DIR) $(1)/lib/wifi
	$(CP) $(PKG_BUILD_DIR)/RT2870STA.dat $(1)/etc/Wireless/RT2870STA/
	$(INSTALL_DATA) ./files/lib/wifi/wext.sh $(1)/lib/wifi
endef

$(eval $(call KernelPackage,mt7601u-porjo))
