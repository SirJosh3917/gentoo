# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils git-r3 xdg-utils

DESCRIPTION="Cross-platform libmpv-based multimedia player with uncluttered design"
HOMEPAGE="http://bakamplayer.u8sand.net/"
EGIT_REPO_URI="https://github.com/u8sand/Baka-MPlayer.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-video/mpv[libmpv]
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/baka-mplayer-${PV}"

src_prepare() {
	default
	# don't install license, man.gz, install the latter manually
	sed -e "/^INSTALLS/s/\sman\slicense//" -i src/Baka-MPlayer.pro || die
	gunzip DOCS/baka-mplayer.1.gz || die
}

src_configure() {
	eqmake5 \
		INSTROOT="${D}" \
		CONFIG+=install_translations \
		lrelease="$(qt5_get_bindir)"/lrelease \
		lupdate="$(qt5_get_bindir)"/lupdate \
		src/Baka-MPlayer.pro
}

src_install() {
	default
	doman DOCS/baka-mplayer.1
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
