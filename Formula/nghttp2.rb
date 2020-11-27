class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.42.0/nghttp2-1.42.0.tar.xz"
  sha256 "c5a7f09020f31247d0d1609078a75efadeccb7e5b86fc2e4389189b1b431fe63"
  license "MIT"

  bottle do
    rebuild 1
    sha256 "caef493f1b11fb991abc2f3802d221b0d7de8941cb74fee1678cbdd739172b37" => :big_sur
    sha256 "48259656881f1604ecb9c6b95d60ea1e95e62e44407fe641df5129ec9aab9d64" => :catalina
    sha256 "d0e538dc1cf2b150354a3603aab81bfbcdca2f996741c37b1f34dfb181589307" => :mojave
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cunit" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "c-ares"
  depends_on "jansson"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libevent"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-python-bindings
      --without-systemd
    ]

    # requires thread-local storage features only available in 10.11+
    args << "--disable-threads" if MacOS.version < :el_capitan

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
