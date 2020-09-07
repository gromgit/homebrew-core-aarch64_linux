class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.20.tar.xz"
  sha256 "145210ec692382e447579ec5c1651f89aa9cb4f6531bab9c0e54ded82c8ac338"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7209be57d12547f716463fe77cce7eb6b99932272560e47a0325c8165d5eb64b" => :catalina
    sha256 "13a53c56c598f97069ce1a2bbf69bd66f2e671a23afbe37d772155781401796b" => :mojave
    sha256 "a1da8adcb9365091637131bc78d637f11020702a340381035e4019cac4eec6ee" => :high_sierra
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
