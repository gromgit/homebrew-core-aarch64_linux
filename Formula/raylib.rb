class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/3.5.0.tar.gz"
  sha256 "761985876092fa98a99cbf1fef7ca80c3ee0365fb6a107ab901a272178ba69f5"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    cellar :any
    sha256 "e7429c2349ffd43bee8f7e412e0e0cdbb5d1c57601347abd968fad8e91165f39" => :big_sur
    sha256 "36271bac2ece0ae5efcfa2b55738242c6786f61a23dbd0567a155e18422a49e6" => :catalina
    sha256 "a6d93094325dc1d8dd5520e92caeab935606456f9b5b3c46995e78c5839cc557" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DSTATIC_RAYLIB=ON",
                         "-DSHARED_RAYLIB=ON",
                         "-DMACOS_FATLIB=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_GAMES=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <raylib.h>
      int main(void)
      {
          int num = GetRandomValue(42, 1337);
          return 42 <= num && num <= 1337 ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lraylib", "-o", "test"
    system "./test"
  end
end
