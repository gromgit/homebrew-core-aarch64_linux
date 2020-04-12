class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.8/axel-2.17.8.tar.xz"
  sha256 "19c82a095e3ea84f1e24fe6fd6018ee06af73ee03ca8ecf31b34dcc57ef4351e"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    cellar :any
    sha256 "f12f3ffed7b2957dbc3477bbcf14569a98e27e52daaa52506b43f4d2834db69a" => :catalina
    sha256 "ff420fc6ddda19d06e2c74f8060730dd53b44022caf86a5a89c266bac8917c64" => :mojave
    sha256 "e3e948578de22fd1cd44b24c38456cad1ccdf0c708b843685576d44c5e2d36d9" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
