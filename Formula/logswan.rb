class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/2.1.11.tar.gz"
  sha256 "a031b04c2dcfe8195e4225b8dd5781fc76098b9d19d0e4a9cbe1da76a4928eea"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6a7fcf48c1fc356205b40d562aaca9dfdef8d95754ab7c9f40fd3a6ed8156b38"
    sha256 cellar: :any,                 arm64_big_sur:  "afb48912039caff60cbce487a553e53be81a1172997d4f87a8034af7e2852f40"
    sha256 cellar: :any,                 monterey:       "c8a002bede190b80e1c15e3b1000d160a43fd55ec54352b1b70c38a7c6ea7532"
    sha256 cellar: :any,                 big_sur:        "f78bc4c2215dcaa65349ccdcfde243337394c993b5c1606966b2f1b7541a2e9f"
    sha256 cellar: :any,                 catalina:       "29abf4996ce39567fab359d0e0b0d7782d466b7e144bdc651f0ac6460da7e3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a450c88007a646733c2af06ef8fd9ae5dbd5e66c49baaa3d297c6f54ce228425"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libmaxminddb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    assert_match "visits", shell_output("#{bin}/logswan #{pkgshare}/examples/logswan.log")
  end
end
