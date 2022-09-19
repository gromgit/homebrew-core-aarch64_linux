class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v14.0.0.tar.gz"
  sha256 "f9fc9765217cbd10e3a3e3883a60fc8f2dbbeaac634b45c789577a8a87999a01"
  license "MIT"
  revision 3
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4595bcff1f53ba6f0128693cb797cdf5d57f5f20b7c29ba11ca594019ed9965d"
    sha256 cellar: :any,                 arm64_big_sur:  "88b6ff2cfe7f1fbe59c3da39866b5b7413bcfb6e4262135488b9c5904cba5523"
    sha256 cellar: :any,                 monterey:       "d98d22642681032e45f46b03d3d0a97923f9569a186a030450da2c545698e7f7"
    sha256 cellar: :any,                 big_sur:        "afc7bc359689f5adecf590be08d755f89f684fa322475d2433ad47bf42fc0cfb"
    sha256 cellar: :any,                 catalina:       "ae2cc890185d2fb68ffa3665ce362d653c683353835377ce23f478fd76ac91b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f311085eeae716f884dc957c31fb7640c1159afb32d17a3985093dca68c8be30"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "llvm@14"
  depends_on "python@3.10"

  fails_with gcc: "5" # LLVM is built with Homebrew GCC

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DHalide_SHARED_LLVM=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
