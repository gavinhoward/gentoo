# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Protocol Buffers for Go with Gadgets"
HOMEPAGE="https://github.com/protocolbuffers/${PN}"
SRC_URI="https://github.com/protocolbuffers/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
# The maintainer (Gavin D. Howard) must be contacted on every package release
# because a redirect is required to make Gitea give a nice URL like this.
SRC_URI+=" https://git.gavinhoward.com/gavin/protobuf-go/releases/${PV}/${P}-deps.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
DEPEND="
	dev-libs/protobuf
"
RDEPEND="
	${DEPEND}
"
RESTRICT="!test? ( test )"

EGO_SUM=(
	'github.com/golang/protobuf v1.5.0'
	'github.com/golang/protobuf v1.5.0/go.mod'
	'github.com/google/go-cmp v0.5.5'
	'github.com/google/go-cmp v0.5.5/go.mod'
	'golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543'
	'golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod'
	'google.golang.org/protobuf v1.26.0-rc.1/go.mod'
)

src_unpack() {
	if use test; then
		go-module_src_unpack
	else
		default
	fi
}

src_compile() {
	export GOBIN=${S}/bin
	export GOOS=linux
	ego build -o bin/protoc-gen-go ./cmd/protoc-gen-go
}

src_install() {
	dobin bin/*
	dodoc README.md
}
