class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.42.0/nghttp2-1.42.0.tar.xz"
  sha256 "c5a7f09020f31247d0d1609078a75efadeccb7e5b86fc2e4389189b1b431fe63"
  license "MIT"

  bottle do
    sha256 "05a32909b92b1e546c20d5722cf0ede751757d6865de0e8a3c030609b36406bc" => :big_sur
    sha256 "52cdad0d7525cd28ce3e1b0efd9c677457dc6c51a729ae9f760d2a55bde51e1a" => :catalina
    sha256 "5459e23d7214299f8e227a0fe204f43baca8fad45a845990c165c7db6ce1b192" => :mojave
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

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-python-bindings
      --with-xml-prefix=/usr
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
