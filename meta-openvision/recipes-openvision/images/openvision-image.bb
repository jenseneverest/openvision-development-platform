require conf/license/openvision-gplv2.inc

inherit image

DEPENDS += "zip-native"

WIFI_DRIVERS = " \
	firmware-carl9170 \
	firmware-htc7010 \
	firmware-htc9271 \
	firmware-rt2870 \
	firmware-rt73 \
	firmware-rtl8712u \
	firmware-rtl8192cu \
	firmware-rtl8188eu \
	firmware-zd1211 \
	\
	kernel-module-ath9k-htc \
	kernel-module-carl9170 \
	kernel-module-r8712u \
	kernel-module-rt2500usb \
	kernel-module-rt2800usb \
	kernel-module-rt73usb \
	kernel-module-rtl8187 \
	kernel-module-rtl8192cu \
	kernel-module-zd1211rw \
	"

WIFI_BSP_DRIVERS ?= " "

IMAGE_INSTALL = "\
	${ROOTFS_PKGMANAGE} \
	${WIFI_DRIVERS} \
	${WIFI_BSP_DRIVERS} \
	avahi-daemon \
	ca-certificates \
	distro-feed-configs \
	dropbear \
	e2fsprogs-e2fsck \
	e2fsprogs-mke2fs \
	e2fsprogs-tune2fs \
	fakelocale \
	glibc-binary-localedata-en-gb \
	hdparm \
	kernel-params \
	modutils-loadscript \
	nfs-utils-client \
	openssh-sftp \
	openvision-linuxsat-feed-config \
	openvision-video-bootlogo \
	opkg \
	packagegroup-base \
	packagegroup-core-boot \
	parted \
	${PYTHONNAMEONLY}-ipaddress  \
	${PYTHONNAMEONLY}-netifaces \
	sdparm \
	tuxbox-common \
	tzdata \
	util-linux-ionice \
	util-linux-mount \
	volatile-media \
	vsftpd \
	"

export IMAGE_BASENAME = "openvision"
IMAGE_LINGUAS = ""
IMAGE_FEATURES += "package-management"

# Remove the mysterious var/lib/opkg/lists that appears to be the result
# of the installer that populates the rootfs. I wanted to call this
# rootfs_remove_opkg_leftovers but that fails to parse.
rootfs_removeopkgleftovers() {
  rm -r ${IMAGE_ROOTFS}${localstatedir}/lib/opkg/lists
}

# Some features in image.bbclass we do NOT want, so override them
# to be empty. We want to log in as root, but NOT via SSH. So we want
# to live without debug-tweaks...
zap_root_password () {
	true
}

license_create_manifest() {
}

do_openvision_chwon_root_image(){
  chown -hR root:root ${IMAGE_ROOTFS}
}

ROOTFS_POSTPROCESS_COMMAND_append = " \
  rootfs_removeopkgleftovers; \
  do_openvision_chwon_root_image; \
"
