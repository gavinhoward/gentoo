# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GNU/Linux application firewall"
HOMEPAGE="https://github.com/evilsocket/opensnitch"
# For some reason, they number their RC releases with a dot before the number,
# so this is explicit.
SRC_URI="
	https://github.com/evilsocket/opensnitch/archive/refs/tags/v1.6.0-rc.5.tar.gz
	-> ${PN}-${PV}.tar.gz
"
S=${WORKDIR}/${PN}-1.6.0-rc.5

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="
	systemd
	ebpf
"

DEPEND="
	sys-libs/glibc
	dev-lang/python
	dev-python/grpcio-tools
	dev-python/pyinotify
	dev-python/unicode-slugify
	dev-qt/qtchooser
	dev-python/QtPy[pyqt5,sql]
	dev-python/protobuf-python
	dev-lang/go
	dev-go/protobuf-go
	net-libs/libpcap
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink
	ebpf? (
		net-misc/opensnitch-ebpf-kmod
	)
	systemd? ( sys-apps/systemd )
	!systemd? ( sys-apps/openrc )
"

RDEPEND="
	${DEPEND}
"


