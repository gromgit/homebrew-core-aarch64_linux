class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://www.blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.21.1.tar.gz"
  sha256 "f387149eab24efa01c308e4cba0f59f64ccae57292ec9c794002232f7903b55b"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/c-blosc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "01df13590f40016c22d919b7da3ddeff53627e169fe5e56ddb25df4502a77c72"
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
