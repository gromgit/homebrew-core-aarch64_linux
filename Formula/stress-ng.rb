class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.12.tar.xz"
  sha256 "0ccf437ca1876a3e8a55986c6481697045203a17f5994cb2f5096cd461d18031"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4c93f3d965ce97cdf1111507dd8d50cc3c0e23d6d3667f11a0c3afaa4cb9cae" => :catalina
    sha256 "d5866ef496fa55bc0dd4d89d1ae97bc4a44004a312df231cb36819f32fcc5515" => :mojave
    sha256 "ad2ee58899ecf1a20a46f4e9f6e03d6fccdfc83505e2d68655b528e924744be4" => :high_sierra
  end

  depends_on :macos => :sierra

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
