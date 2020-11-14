class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.24.tar.xz"
  sha256 "5b3a724a85eed48743dedf37eab851b617ecf921b7fff427c6d0bbf405534671"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "48fbca2f6974d709abd360efd322b0c22549c0e11277aea1f3b555d4c50fc128" => :catalina
    sha256 "8b120cda837413570388f3b38439747da961a9059c36ed5ce7e233f0bfeffbf9" => :mojave
    sha256 "316abbed224fb69032213a815d196417b30bbec27c7a6e4af216c17b58d0ba63" => :high_sierra
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
