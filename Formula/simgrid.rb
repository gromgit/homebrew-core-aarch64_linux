class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://framagit.org/simgrid/simgrid/uploads/6ca357e80bd4d401bff16367ff1d3dcc/simgrid-3.29.tar.gz"
  sha256 "83e8afd653555eeb70dc5c0737b88036c7906778ecd3c95806c6bf5535da2ccf"

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "71d9b098d5fd0039bbc7005555d0f1abbc1af8d816a8946629f55046a1b47615"
    sha256 big_sur:       "def3ab73795d0c11ce112ad3fb3abcd325815bda779637961c6a8b4c43e1ef06"
    sha256 catalina:      "ee5bc62941284de0277bc1ea39467ea06c4cb611d8144a689c2060a1b2c3588e"
    sha256 mojave:        "b7c787533f73e4a8fcfa07f50171879e949ffc1d615c680ccb98bd985e14de60"
    sha256 x86_64_linux:  "4a050cf056536a6d8574c22d5c8aebf4a6b19b0874019596a171d58523a73eea"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "pcre"
  depends_on "python@3.9"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Avoid superenv shim references
    inreplace "src/smpi/smpicc.in", "@CMAKE_C_COMPILER@", DevelopmentTools.locate(ENV.cc)
    inreplace "src/smpi/smpicxx.in", "@CMAKE_CXX_COMPILER@", DevelopmentTools.locate(ENV.cxx)

    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    "-Denable_fortran=off",
                    *std_cmake_args
    system "make", "install"

    bin.find { |f| rewrite_shebang detected_python_shebang, f }
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
