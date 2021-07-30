class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.2.2.tar.gz"
  sha256 "ed77d762199e9a2617325d6fe1ab88dbf53d8149a9952622298835e8c39bb706"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "84fb31a4ef00ac981fea8c37354ee9a6460c93f2756fffed8f3511126c3c7107"
    sha256 cellar: :any, big_sur:       "0eb4bb61482f4985919fa6a5a1907090eb1a7c3ac507e384f112fce9c7afc146"
    sha256 cellar: :any, catalina:      "a6c562298b9f840a535e67c4a1af2cd2cee7a64b148867dffbd5c43abe449fac"
    sha256 cellar: :any, mojave:        "62bef7ab66b3080369802009fce876879f6a756fc6f2734de0e33a514fa8bf93"
    sha256 cellar: :any, high_sierra:   "802c42ae842ebed113639b7e647da9eb09d8fddde91b9d2938652849f2543a06"
    sha256 cellar: :any, sierra:        "0c505d90e236906a294afbd5989a79e503c4ae2afbfa3a8727ffb96969b4a6c9"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    on_macos { args << "OSCONFIGFILE=macos.mk" }

    system "make", "install", *args
    pkgshare.install %w[.testfile test.c]
  end

  test do
    cp_r pkgshare/".testfile", testpath
    system ENV.cc, pkgshare/"test.c", "-std=c99", "-O3", "-I#{include}", "-L#{lib}", "-lkeccak", "-o", "test"
    system "./test"
  end
end
