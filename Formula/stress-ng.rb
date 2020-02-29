class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.01.tar.xz"
  sha256 "9fe19548c87aa1a1b9b2be3b359ec2621b88bcb16998b77527549a7736f65494"

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
