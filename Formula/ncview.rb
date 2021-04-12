class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://cirrus.ucsd.edu/ncview/"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.8.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview-2.1.8.tar.gz"
  sha256 "e8badc507b9b774801288d1c2d59eb79ab31b004df4858d0674ed0d87dfc91be"
  license "GPL-3.0-only"
  revision 4

  # The stable archive in the formula is fetched over FTP and the website for
  # the software hasn't been updated to list the latest release (it has been
  # years now). We're checking Debian for now because it's potentially better
  # than having no check at all.
  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/ncview/"
    regex(/href=.*?ncview[._-]v?(\d+(?:\.\d+)+)(?:\+ds)?\.orig\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "619a756d4299ac0716afeb1992079e71aedf3aa9e3844f647799355284f3b974"
    sha256 big_sur:       "5632d699eb129f1269db64d51543172e16eb917e66e97f3b8564ff0a2f8b8d04"
    sha256 catalina:      "9540269483a1f5de488fa521a28e731852c1de1618b5f7e987d15b5cc8a7cca5"
    sha256 mojave:        "58fdac82ed65edf9517943126b5e3ab345db75850fe3e42a1c7b3d0fa2530056"
  end

  depends_on "libice"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxt"
  depends_on "netcdf"
  depends_on "udunits"

  def install
    # Bypass compiler check (which fails due to netcdf's nc-config being
    # confused by our clang shim)
    inreplace "configure",
      "if test x$CC_TEST_SAME != x$NETCDF_CC_TEST_SAME; then",
      "if false; then"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install "data/ncview.1"
  end

  test do
    assert_match "Ncview #{version}",
                 shell_output("DISPLAY= #{bin}/ncview -c 2>&1", 1)
  end
end
