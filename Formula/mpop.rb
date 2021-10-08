class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.15.tar.xz"
  sha256 "3f52b2b5d4bc58ed93cf0b1146cee4f74de81c2c07a25ee032efa659465a0270"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "ffa7d1d7240b1fe9913f3f7f104cf410325e3e15de646cfc7d508db65c7a4288"
    sha256 big_sur:       "4b8ef4bdfbc2eb722f2c0698207f4b8380efe396bb2dde01ee9ab15905c77961"
    sha256 catalina:      "47eb7901c79b0c2c0110d0d536851af477ff5626a8a46a8ba2fc1551ea790a7c"
    sha256 mojave:        "afaf7fa8399df4285ec412ba7b89f0d19bcbc21fad7029dfb7ae5092c0af8efb"
    sha256 x86_64_linux:  "0813016d1ca4ea0dbc41c22a58cc675cc6723b87fc0374f6228434277ff3403f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  # Both of these patches are needed on top of 1.4.15 to fix build on macOS.
  # Remove in next release. Build dependencies autoconf and automake can also
  # be removed in next release, as well as the autoreconf call in the install block.
  # See https://github.com/marlam/mpop-mirror/issues/9
  patch do
    url "https://git.marlam.de/gitweb/?p=mpop.git;a=patch;h=68693b7da5d037ac31954db00c210daa28f2ea74"
    sha256 "f6bc137aaa6c8bcf6b608167108e2d2d4d255f61f7323d789da4cd028ada84a2"
  end

  patch do
    url "https://git.marlam.de/gitweb/?p=mpop.git;a=patch;h=64f8dc2b39d9e967e09b234993e096f4441ae87a"
    sha256 "f920d7897a38de14f30388cc3f62200992ab5bd054e5b250085af013590b3607"
  end

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
