class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.02.tar.xz"
  sha256 "f847be115f60d3ad7d37c806fd1bfb1412aa3c631fca581d6dc233322f50d6a5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6f212d5e33bc2f13d0b952676842988c9022401f627ff50fff601b6da4cd5c8d" => :big_sur
    sha256 "a18c5ae8dfb0de885ec3edd83870b93d8a34c110303e538fc8cfc6804b6db1ef" => :arm64_big_sur
    sha256 "36d908f8f89d5cb9768951ed0ff5775a4df900684eb253c3abc5537d54615b1d" => :catalina
    sha256 "b0e205395669314015bd91acd6215d2556a4387b5f42d4e5cd2dd551190a1cb3" => :mojave
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
