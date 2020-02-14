class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.00.tar.xz"
  sha256 "a41a6a4a7ea4e50aab7331e5594af7d1b3b6e5815751d137a78a6e166295294e"

  bottle do
    cellar :any_skip_relocation
    sha256 "17fea028edc17e3f151cad1637e9fc26d1eca922a890b2ca6d164da7d779ffd6" => :catalina
    sha256 "c85b7a4c7392af00277ddd75e6a4d4e81ad9c6c41d52b4a6c93d3271c762fe04" => :mojave
    sha256 "36e73adf024b64b4e08b0109d0903560258aeb58f071975f5ae8faf543d9ade8" => :high_sierra
  end

  depends_on :macos => :sierra

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
