class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.08.tar.xz"
  sha256 "39e98cbb682bd3f907b2c718c20747bc94804abc92fbc4dad3a50bf530108d09"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "29da01a8baf42d0402de9fa4167a83c6b86e1b274fb522567cde7de3c1962138"
    sha256 cellar: :any_skip_relocation, big_sur:       "67108fcb436ea35b865d03a8b00388d6e444827b6ff3d0d94ba30df17a70a1a2"
    sha256 cellar: :any_skip_relocation, catalina:      "369210742c7cf985368e94fe0ad4da7f4c64ef86bc28b128c3c26f49ab364558"
    sha256 cellar: :any_skip_relocation, mojave:        "6f7a8b19d69c2ed7eef85fbe63510d98a164080f327f09988a9d3fabbd0d21a0"
  end

  depends_on macos: :sierra

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
