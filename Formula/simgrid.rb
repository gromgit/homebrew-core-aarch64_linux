class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/0365f13697fb26eae8c20fc234c5af0e/SimGrid-3.25.tar.gz"
  sha256 "0b5dcdde64f1246f3daa7673eb1b5bd87663c0a37a2c5dcd43f976885c6d0b46"

  bottle do
    sha256 "ad770f08175c732a0d41fb8ce9cd0c5522d3276b8f062560cfe2b638529481da" => :catalina
    sha256 "198a2b92621a35673354f863488168d7daae940f200f319a3565d1b37d021c50" => :mojave
    sha256 "d458ff1173916ee455577e3873cb46a5c5d2d4194d7146ef945cf5e28908a23f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "pcre"
  depends_on "python"

  def install
    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    "-DCMAKE_C_COMPILER=clang",
                    "-DCMAKE_CXX_COMPILER=clang++",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <simgrid/engine.h>

      int main(int argc, char* argv[]) {
        printf("%f", simgrid_get_clock());
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsimgrid",
                   "-o", "test"
    system "./test"
  end
end
