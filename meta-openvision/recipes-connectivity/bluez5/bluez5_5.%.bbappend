FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://tools-Add-support-for-rtk_h5-type.patch"

EXTRA_OECONF += "--disable-udev"

DEPENDS := "${@oe.utils.str_filter_out('udev', '${DEPENDS}', d)}"

RDEPENDS_${PN}-testtools = "${@bb.utils.contains("PYTHONEXACTVERSION", "python3", "python3-core", "python", d)} ${PYTHONNAMEONLY}-dbus ${@bb.utils.contains('GI_DATA_ENABLED', 'True', '${PYTHONNAMEONLY}-pygobject', '', d)}"
