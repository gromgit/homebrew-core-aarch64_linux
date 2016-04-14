class Openlitespeed < Formula
  desc "High-performance, lightweight HTTP server"
  homepage "http://open.litespeedtech.com/mediawiki/"
  url "http://open.litespeedtech.com/packages/openlitespeed-1.3.10.tgz"
  sha256 "703ff1093eae270bb0c380d097e92e39dd102b31f9632ff420b4b0ed423c4159"
  head "https://github.com/litespeedtech/openlitespeed.git"

  bottle do
    sha256 "94e67dcd4a54a50c080630976731f6a52d84423dd2d8e0b3337d95d904d94170" => :el_capitan
    sha256 "97dc0e8e814978e6d42997fd092b7ed26e63aca96b8c6f96583bb093d1e895f8" => :yosemite
    sha256 "aacafddf229c07c76481f3fc86b3295ca06b41e14555b0e8a97050098701a1d2" => :mavericks
  end

  option "with-debug", "Compile with support for debug log"
  option "with-spdy", "Compile with support for SPDY module"

  depends_on "pcre"
  depends_on "geoip"
  depends_on "openssl"

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-debug" if build.with? "debug"
    args << "--enable-spdy" if build.with? "spdy"
    args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "./configure", *args
    system "make", "install"
  end
end
