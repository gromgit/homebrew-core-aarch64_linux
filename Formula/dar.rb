class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.6.8/dar-2.6.8.tar.gz"
  sha256 "4365943798add9554a1ccf6514186a6146d421812eb9d767b7744a524035bc16"

  bottle do
    cellar :any
    sha256 "d8e944fd57faae5a24a0e8c89a5a6253a6eefac068ef982f14457dd94b122f90" => :catalina
    sha256 "a9856877edb9fee60a5d4d5de91c16e0f88c69738a28d959f87982743f956f89" => :mojave
    sha256 "cdd7a97c5793396bd1907b2b45bda5ef5b073b5acaab4ab71c7942f8988cced0" => :high_sierra
  end

  depends_on "upx" => :build
  depends_on "libgcrypt"
  depends_on "lzo"
  depends_on :macos => :el_capitan # needs thread-local storage

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-libxz-linking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
