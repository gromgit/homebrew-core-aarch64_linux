class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/v0.7.3.tar.gz"
  sha256 "d3bcc4ef21c033a0cc408a30186bb3dbe21219e0c52d328ca70eb688cf867354"

  bottle do
    cellar :any
    sha256 "d8fffb8ca17e9ca870d0c7a41195de061f59d9f26d0373c1c7e6f91d016f92fc" => :big_sur
    sha256 "83e9c076e9376c4bcd1cf0fa694e4bb4ad6ffd55f0e230c1baf7cda461d3ccd5" => :catalina
    sha256 "0ac5dc628f60e37f5f4285f860d4e94fe99e4f2f2ab9e7416e0c887ee1d98f0a" => :mojave
    sha256 "b7e6d444189106624ec496e00e79f3e9e9c1236f4908e846086a9e27421a4466" => :high_sierra
  end

  keg_only :provided_by_macos

  def install
    lib.mkpath
    (lib/"pkgconfig").mkpath
    (include/"openlibm").mkpath

    system "make", "install", "prefix=#{prefix}"

    lib.install Dir["lib/*"].reject { |f| File.directory? f }
    (lib/"pkgconfig").install Dir["lib/pkgconfig/*"]
    (include/"openlibm").install Dir["include/openlibm/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "openlibm.h"
      int main (void) {
        printf("%.1f", cos(acos(0.0)));
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/openlibm",
           "-o", "test"
    assert_equal "0.0", shell_output("./test")
  end
end
