class Bgpstream < Formula
  desc "For live and historical BGP data analysis"
  homepage "https://bgpstream.caida.org/"
  url "https://github.com/CAIDA/libbgpstream/releases/download/v2.0.0/libbgpstream-2.0.0.tar.gz"
  sha256 "f9e377856fb282ac93277c4c5a35b421b8cef5a72e8d671c40f4d7722be0bac7"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "4922818badaa6fad60296cbc3337281f12aeda5bcde30beee22e3171f84bf8b5" => :big_sur
    sha256 "9a86090dfd836211fdf98d48b4ac8927e798f1e35f684166663567319b987e25" => :catalina
    sha256 "8ff3a6037432e94a4677b4fc9db898705ff4cbf25db175941fe2b3d8cf751e0b" => :mojave
  end

  depends_on "librdkafka"
  depends_on "wandio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "bgpstream.h"
      int main()
      {
        bgpstream_t *bs = bs = bgpstream_create();
        if(!bs) {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbgpstream", "-o", "test"
    system "./test"
  end
end
