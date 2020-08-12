class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.18.tar.xz"
  sha256 "07c82a5c89538b5b696a79192faa70d0232352004c9e532946f7f3613d0adf23"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d1828bffc59f3c2362dc384459a3a77fe590c22c7b0870590c43f15ef1c796b" => :catalina
    sha256 "3f24d951bb942d2371643041d3a40a749bb0d7582dbbea7de9d0baa57a53be59" => :mojave
    sha256 "ce6ba7b9462527da068ccc3252e22ce1635cc31d2c7c4f7048b6b462d23e0168" => :high_sierra
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
