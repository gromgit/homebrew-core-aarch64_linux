class Rtorrent < Formula
  desc "Console-based BitTorrent client"
  homepage "https://github.com/rakshasa/rtorrent"
  url "http://rtorrent.net/downloads/rtorrent-0.9.6.tar.gz"
  sha256 "1e69c24f1f26f8f07d58d673480dc392bfc4317818c1115265b08a7813ff5b0e"

  bottle do
    cellar :any
    sha256 "74df05e0d84fa0c8cb7f05ef17e7df98c30103f67f01bdc3935f37c6732832d0" => :el_capitan
    sha256 "ac506ab6ba1e7913c44473929f0324d039bbee8e6a43a1619de8cb74ace7863c" => :yosemite
    sha256 "7df1b4606e2e0e00fc11ade307f231b29c3d885a03b755bc3ea84feba7547b82" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cppunit" => :build
  depends_on "libtorrent"
  depends_on "xmlrpc-c" => :optional

  # https://github.com/Homebrew/homebrew/issues/24132
  fails_with :clang do
    cause "Causes segfaults at startup/at random."
  end

  def install
    # Commented out since we're now marked as failing with clang - adamv
    # ENV.libstdcxx if ENV.compiler == :clang

    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--with-xmlrpc-c" if build.with? "xmlrpc-c"
    if MacOS.version <= :leopard
      inreplace "configure" do |s|
        s.gsub! '  pkg_cv_libcurl_LIBS=`$PKG_CONFIG --libs "libcurl >= 7.15.4" 2>/dev/null`',
          '  pkg_cv_libcurl_LIBS=`$PKG_CONFIG --libs "libcurl >= 7.15.4" | sed -e "s/-arch [^-]*/-arch $(uname -m) /" 2>/dev/null`'
      end
    end
    system "sh", "autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"

    doc.install "doc/rtorrent.rc"
  end
end
