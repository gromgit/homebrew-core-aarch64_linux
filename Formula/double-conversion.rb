class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/v3.2.1.tar.gz"
  sha256 "e40d236343cad807e83d192265f139481c51fc83a1c49e406ac6ce0a0ba7cd35"
  license "BSD-3-Clause"
  head "https://github.com/google/double-conversion.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/double-conversion"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2ac67b8f6800fc38da9bb2eef053eb82b3c6dbcbd9ee964cf10fa215d5b03664"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "shared"
    system "cmake", "--install", "shared"

    system "cmake", "-S", ".", "-B", "static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "static"
    lib.install "static/libdouble-conversion.a"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <double-conversion/bignum.h>
      #include <stdio.h>
      int main() {
          char buf[20] = {0};
          double_conversion::Bignum bn;
          bn.AssignUInt64(0x1234567890abcdef);
          bn.ToHexString(buf, sizeof buf);
          printf("%s", buf);
          return 0;
      }
    EOS
    system ENV.cc, "test.cc", "-L#{lib}", "-ldouble-conversion", "-o", "test"
    assert_equal "1234567890ABCDEF", `./test`
  end
end
