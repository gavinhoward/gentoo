# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SULLR
DIST_VERSION=2.052
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Nearly transparent SSL encapsulation for IO::Socket::INET"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="idn"

RDEPEND="
	>=dev-perl/Net-SSLeay-1.460.0
	virtual/perl-Scalar-List-Utils
	idn? (
		|| (
			>=dev-perl/URI-1.50
			dev-perl/Net-LibIDN
			dev-perl/Net-IDN-Encode
		)
	)"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
mydoc=("docs/debugging.txt")
