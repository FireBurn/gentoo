# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pbr
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/getpatchwork/git-pw.git"
else
	SRC_URI="https://github.com/getpatchwork/git-pw/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A tool for integrating Git with Patchwork"
HOMEPAGE="https://github.com/getpatchwork/git-pw"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=dev-python/arrow-0.10[${PYTHON_USEDEP}]
	>=dev-python/click-6.0[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]
	<dev-python/requests-3.0[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.8[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		>=dev-python/mock-3.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_compile() {
	export PBR_VERSION=${PV}
	distutils-r1_src_compile
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
