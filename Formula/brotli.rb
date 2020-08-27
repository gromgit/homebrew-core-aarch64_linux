class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.9.tar.gz"
  sha256 "f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46"
  license "MIT"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "6526006014d703cc325a97f73234eebc47e6e1d0cb1b85e7f97f6303313c9252" => :catalina
    sha256 "d93ab99600d4be250aada81cc09b4eced621f988e86f056ca7bea43925e253fa" => :mojave
    sha256 "0afb60c1f605ca7a3b862eee22a0c16f9b9a8f938c1eec10e62502364d0dcbe1" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "VERBOSE=1"
    system "ctest", "-V"
    system "make", "install"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system "#{bin}/brotli", "file.txt", "file.txt.br"
    system "#{bin}/brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
