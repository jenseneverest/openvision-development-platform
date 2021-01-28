SUMMARY = "oZeta Openvision Skin"
MAINTAINER = "Lululla - mmark"
SECTION = "misc"
PRIORITY = "optional"
LICENSE = "proprietary"

require conf/license/license-gplv2.inc

inherit gitpkgv allarch

PV = "git${SRCPV}"
PKGV = "git${GITPKGV}"

SRC_URI = "git://github.com/jenseneverest/oZeta-skin.git;protocol=git"

S = "${WORKDIR}/git"

FILES_${PN} = "${prefix}"

do_package_qa[noexec] = "1"

require skin-data.inc
