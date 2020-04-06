class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.18.1.tar.gz"
  sha256 "18730e3d1139aadf4002759ef83c8327509a9fca140661deb1d050aebba35afb"

  bottle do
    cellar :any
    sha256 "e5c1ff27df2c10c25dbcd67ab310a5501289f92a32a1e35447e457051231fb3e" => :catalina
    sha256 "8be78650b7cb188454b276fcc955f42715f69b63bcbe65fd007d74db58fb8082" => :mojave
    sha256 "c99be45076e37c02515e3cb4bdf4cbaeb1508569d1d3e4afae161663eed4493c" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
