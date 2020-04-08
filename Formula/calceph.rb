class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.4.3.tar.gz"
  sha256 "8f27c05d7048b6b3f67c42824eebd158bae7bf257031c01d4912dd38a40b0218"

  bottle do
    cellar :any
    sha256 "bb817a145083c98a8b039eef2e5031c95e3b0ef0cc2b4ebfb6bd60a42cca99c1" => :catalina
    sha256 "9bcc71457af07affab684701289f44ffdba4d0abbbf59640fdceff2627e240af" => :mojave
    sha256 "c257553180788677d38720266140209de9cc45f97752255b54d27a4d09614f8e" => :high_sierra
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"testcalceph.c").write <<~EOS
      #include <calceph.h>
      #include <assert.h>

      int errorfound;
      static void myhandler (const char *msg) {
        errorfound = 1;
      }

      int main (void) {
        errorfound = 0;
        calceph_seterrorhandler (3, myhandler);
        calceph_open ("example1.dat");
        assert (errorfound==1);
        return 0;
      }
    EOS
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end
