class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.1.2.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/cpl/cpl-7.1.2.tar.gz/sha512/0835917153fdcf4e7908f9261e143dc54fe7b50dc7903c2041a23a1984554b94a99584def70a792d9fe44a42830bc2baee397635ce922848d514a580be59348a/cpl-7.1.2.tar.gz"
  sha256 "b6d20752420e2333e86d9a08c24a08057351a9fef97c32f5894e63fbfece463a"
  license "GPL-2.0-or-later"
  revision 6

  livecheck do
    url "https://www.eso.org/sci/software/cpl/download.html"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "7ebb518afea5306674b1b4fe01826e3e3f3531eaf5f0d87069df31f88475caca"
    sha256 cellar: :any, big_sur:       "740461b2b2bde934347eec401daa1322bd54d726c7ec9902561a629042bfa16f"
    sha256 cellar: :any, catalina:      "458b9de38a1e292da0e9d70b453dc7ca8bc199b253c2a1120bb61d608595497c"
    sha256 cellar: :any, mojave:        "dcaa92d135d443432230d2ac087f73f87e515959d42950eeb19419aebe926158"
  end

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "wcslib"

  conflicts_with "gdal", because: "both install cpl_error.h"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                          "--with-fftw=#{Formula["fftw"].prefix}",
                          "--with-wcslib=#{Formula["wcslib"].prefix}",
                          # Needed for 7.1.2's ./configure to work under Xcode 12:
                          "CC=#{ENV.cc} -Wno-implicit-function-declaration"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <cpl.h>
      int main(){
        cpl_init(CPL_INIT_DEFAULT);
        cpl_msg_info("hello()", "Hello, world!");
        cpl_end();
        return 0;
      }
    EOF
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lcplcore", "-lcext", "-o", "test"
    system "./test"
  end
end
