class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_107.tar.gz"
  sha256 "c09a7e0eb0fbfdfc807d13e8af9305e9805b8fdc499d9f886f5cf2e3fce5b5cf"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "47c126eea892b4830035e18b8ba742e991f6b36523aa8f5bc1e3ccd252549af6"
    sha256 cellar: :any,                 arm64_big_sur:  "4d4f8e84ecf174138b84c2a566c57656ea0fd12107c78cf7381fa563a68ab552"
    sha256 cellar: :any,                 monterey:       "edc98ef41f4cea805a0136ef4ce32fa2e766bdedb4bd24980bf4cce9a4bf2d7d"
    sha256 cellar: :any,                 big_sur:        "b43faef3cd936e6475c4b023bfb6a5626ec324accb19b3387e0a7d8d2b8e225f"
    sha256 cellar: :any,                 catalina:       "c9b697190da76ae1cb4871b621566e02da3fee55cfb46db2994359fb2c64b734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfebee00509ee5a41293405405c750fcd0d736bd3b4b681dc7d555ecf6273ad9"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_TESTS=false"
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", File.read("1.wast")
  end
end
