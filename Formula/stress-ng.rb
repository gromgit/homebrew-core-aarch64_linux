class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.13.04.tar.xz"
  sha256 "0277943033fc9750aa869b3fa109663f3540d233a3ddc300d3a869ecbd56f451"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a9c4cdcd3320dd42e5f01f640e2df7ee8784e774fbd37536f808e66e73bab28"
    sha256 cellar: :any_skip_relocation, big_sur:       "65f3485fd4d9acd46f50019e9b7b01c1a5216dbf444b695ddd05f63b5c3d4219"
    sha256 cellar: :any_skip_relocation, catalina:      "acc16fe91b71385c687d86c0e1fab8731012ee7217b8302e71cb7b2a9c1b4a87"
    sha256 cellar: :any_skip_relocation, mojave:        "1d3f609b072b3466828b2c5afae1c77462bdecb7339d6cd597e09c0503f7caf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "461c1f12c60a66d84308231f2cd4bdf9e207452c5995244d95c677e5559ed852"
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
