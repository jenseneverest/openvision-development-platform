inherit upx_compress

PACKAGECONFIG = "openssl pcre zlib ${@bb.utils.filter('DISTRO_FEATURES', 'ipv6', d)}"

CFLAGS_append_sh4 = " -std=gnu99"
