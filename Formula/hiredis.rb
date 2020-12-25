class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v1.0.0.tar.gz"
  sha256 "2a0b5fe5119ec973a0c1966bfc4bd7ed39dbce1cb6d749064af9121fe971936f"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git"

  bottle do
    cellar :any
    sha256 "1d6e99d11a211499f85f80783c3bbf83c4acda50607c409b9120a7e7b685e48d" => :big_sur
    sha256 "d8e48f1d114c2522d9cdf6aed5b0cefb081db02f4bafa43aa6381f495e99c09f" => :arm64_big_sur
    sha256 "5f11389538e1c20397783e2aca46853b013468610d517f6e0e14f37160e0a3c4" => :catalina
    sha256 "9688a9f2a1adf2669c32785d9ca2354b4d79408234a444a21f864b5ecb86c28d" => :mojave
  end

  # remove in next release
  patch do
    url "https://github.com/redis/hiredis/commit/8d86cb4.patch?full_index=1"
    sha256 "2f1b20defbd882c220e2c2d88da8dae970b7fbd6445363303b2ae7b75263f0ff"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, "-I#{include}/hiredis", "-L#{lib}", "-lhiredis",
           pkgshare/"examples/example.c", "-o", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
