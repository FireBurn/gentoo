# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="mpg123"
MY_P="${MY_PN}-${PV}"
inherit flag-o-matic toolchain-funcs libtool multilib-minimal

DESCRIPTION="a realtime MPEG 1.0/2.0/2.5 audio player for layers 1, 2 and 3"
HOMEPAGE="https://www.mpg123.org/"
SRC_URI="https://downloads.sourceforge.net/${MY_PN}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="cpu_flags_x86_3dnow cpu_flags_x86_3dnowext cpu_flags_ppc_altivec alsa coreaudio int-quality ipv6 jack cpu_flags_x86_mmx nas oss portaudio pulseaudio sdl cpu_flags_x86_sse"

# No MULTILIB_USEDEP here since we only build libmpg123 for non native ABIs.
# Note: build system prefers libsdl2 > libsdl. We could in theory add both
# but it's tricky when it comes to handling switching between them properly.
# We'd need a USE flag for both sdl1 and sdl2 and to make them clash.
RDEPEND="
	!<media-sound/mpg123-1.32.3-r100
	!media-libs/libmpg123
	dev-libs/libltdl:0
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/libtool
	virtual/pkgconfig
"
IDEPEND="app-eselect/eselect-mpg123"

DOCS=( AUTHORS ChangeLog NEWS NEWS.libmpg123 README )

src_prepare() {
	default
	elibtoolize # for Darwin bundles
}

multilib_src_configure() {
	local _audio=
	local _cpu=generic_fpu

	# Build fails without -D_GNU_SOURCE like this:
	# error: 'struct hostent' has no member named 'h_addr'
	append-cflags -D_GNU_SOURCE

	filter-lto # bug #951124

	if multilib_is_native_abi ; then
		local flag
		for flag in coreaudio pulseaudio jack alsa oss sdl portaudio nas ; do
			if use ${flag}; then
				_audio+=" ${flag/pulseaudio/pulse}"
			fi
		done
	fi

	use cpu_flags_ppc_altivec && _cpu=altivec
	if [[ $(tc-arch) == amd64 || ${ARCH} == x64-* ]]; then
		use cpu_flags_x86_sse && _cpu=x86-64
	elif use x86 && gcc-specs-pie ; then
		# Don't use any mmx, 3dnow, sse and 3dnowext (bug #164504)
		_cpu=generic_fpu
	else
		use cpu_flags_x86_mmx && _cpu=mmx
		use cpu_flags_x86_3dnow && _cpu=3dnow
		use cpu_flags_x86_sse && _cpu=x86
		use cpu_flags_x86_3dnowext && _cpu=x86
	fi

	local myconf=(
		--with-optimization=0
		--with-audio=dummy
		--with-default-audio="${_audio} dummy"
		--with-cpu=${_cpu}
		--enable-network
		$(use_enable ipv6)
		--enable-int-quality=$(usex int-quality)
		$(multilib_native_enable programs)
	)

	multilib_is_native_abi || myconf+=( --disable-modules )

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	if ! multilib_is_native_abi ; then
		sed -i -e 's:src doc:src/libmpg123:' Makefile || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	mv "${ED}"/usr/bin/mpg123{,-mpg123} || die
	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	eselect mpg123 update ifunset
}

pkg_postrm() {
	eselect mpg123 update ifunset
}
