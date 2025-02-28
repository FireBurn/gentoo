# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SKAJI
DIST_VERSION=v${PV}
DIST_EXAMPLES=("example/*" "benchmarks")
inherit perl-module

DESCRIPTION="Moose minus the antlers"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.140.0
	>=virtual/perl-XSLoader-0.20.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-Devel-PPPort-3.590.0
	>=virtual/perl-ExtUtils-ParseXS-3.220.0
	>=dev-perl/Module-Build-0.400.500
	>=dev-perl/Module-Build-XSUtil-0.190.0
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Fatal
		dev-perl/Test-LeakTrace
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Output
		dev-perl/Test-Requires
		dev-perl/Try-Tiny
	)
"
