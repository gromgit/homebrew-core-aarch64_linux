class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.3.4/tcpreplay-4.3.4.tar.gz"
  sha256 "ee065310806c22e2fd36f014e1ebb331b98a7ec4db958e91c3d9cbda0640d92c"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:  "55ffb5347204c187b5151181efef39586b052340e8dc40635809fc8eb36ed0e6"
    sha256 cellar: :any, catalina: "2268f0760672a512de278ea4c686b976e75589bb374663c1b9ecbf49ada784ca"
    sha256 cellar: :any, mojave:   "7724d4f1f79cd07a77b430e63e541486d8f666785215dfd898ba54ff2aa35186"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdnet"

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-link
      --with-macosx-sdk=#{MacOS.version}
    ]

    system "./autogen.sh"
    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
