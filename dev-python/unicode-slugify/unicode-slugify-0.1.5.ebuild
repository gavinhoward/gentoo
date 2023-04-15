# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit pypi distutils-r1

DESCRIPTION="A slugifier that generates unicode slugs"
HOMEPAGE="
	https://github.com/mozilla/unicode-slugify
	https://pypi.org/project/unicode-slugify/
"
SRC_URI="$(pypi_sdist_url --no-normalize "${PN}" "${PV}")"
S=${WORKDIR}/${P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
