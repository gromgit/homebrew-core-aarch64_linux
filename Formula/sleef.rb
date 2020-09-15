class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/3.5.1.tar.gz"
  sha256 "415ee9b1bcc5816989d3d4d92afd0cd3f9ee89cbd5a33eb008e69751e40438ab"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git"

  bottle do
    cellar :any
    sha256 "c3aec292662ac506d6c8ccae2d6ea45019a5cbd9928b9c9bde35706410aac1c1" => :catalina
    sha256 "a9763b5dc87d218f416769cea9d1f349506dc37ccc102901840acb6667e9c3ec" => :mojave
    sha256 "ef3857646cb8e871f2a50f4f3e44e39debf6ef58cc43b3e82bb576fa0614f8ba" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <math.h>
      #include <sleef.h>

      int main() {
          double a = M_PI / 6;
          printf("%.3f\\n", Sleef_sin_u10(a));
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lsleef"
    assert_equal "0.500\n", shell_output("./test")
  end
end
