class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.9-source.zip"
  sha256 "1055533089015f0837535a0126708678eb1212a80c70f42d8c4ce467d351cb7f"

  livecheck do
    url "https://www.antlr.org/download/"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  bottle do
    cellar :any
    sha256 "7eba6396f9ee8296e836118c91754652f02866c01d1413bd3ce9f65f98144164" => :big_sur
    sha256 "d16dbd88b32577a5eedecfd6e9c9e7f704fc344477dfbc997c88549f0d44f43a" => :catalina
    sha256 "2048b1ea9f2d661f55819e1aa4c9ee7ca8bcccfee7717b5be6bfb9149ac12574" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DANTLR4_INSTALL=ON", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <antlr4-runtime.h>
      int main(int argc, const char* argv[]) {
          try {
              throw antlr4::ParseCancellationException() ;
          } catch (antlr4::ParseCancellationException &exception) {
              /* ignore */
          }
          return 0 ;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}/antlr4-runtime", "test.cc",
                    "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end
