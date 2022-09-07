class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_107.tar.gz"
  sha256 "c09a7e0eb0fbfdfc807d13e8af9305e9805b8fdc499d9f886f5cf2e3fce5b5cf"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "218f55acd750cc293d96800c6a3a8b303371f48717ed5cd11254351dc7666471"
    sha256 cellar: :any,                 arm64_big_sur:  "6e3adab5e2ffdfdc1fb0ec6e6fde941722c515cb90a63a0ba159ddf2b96ad952"
    sha256 cellar: :any,                 monterey:       "13cd326b05ff2cf88ab77d3b95ef04c7f23a888a0fd9e6850c4f52e0f942332d"
    sha256 cellar: :any,                 big_sur:        "389367ae356b3d2232e11aa6128f3fe8bf31f0315def0a267073497645ecdee4"
    sha256 cellar: :any,                 catalina:       "1d2ed8768edeb8b3c89968b08017184e13535ad5da532ef26e5cd4bea9fae1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ae85e5bd82ca544d1f1d6c3aced346336e93fe618d10921f42cff6139206d74"
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
