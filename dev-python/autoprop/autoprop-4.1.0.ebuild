# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Infer properties from accessor methods"
HOMEPAGE="
	https://github.com/kalekundert/autoprop/
	https://pypi.org/project/autoprop/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/signature-dispatch-1.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
