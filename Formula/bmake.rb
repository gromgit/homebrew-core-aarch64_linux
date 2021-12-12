class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20211207.tar.gz"
  sha256 "05533f9249398d3947c9f3b9f854c544283802cf5aafe798cc60bd031f0875b3"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a9be194c7529efc5b1e742c97d3e848af7bb60d9dac5493a9873f2b29581bc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fce38aae4cec7d732e6ce9073fb9aacc6cf1d495dc1ac0cea4e7d6f367df4add"
    sha256                               monterey:       "009333756daefd3251f61378be29dca8b925109ada8e96375b8d782fbb6597c0"
    sha256                               big_sur:        "bad4f82b8ce3ef345f2ebaf0049ea722a34789369cd939f4befe703a99376164"
    sha256                               catalina:       "4a58303672e6df754b8779eee71aa17aeac24dcc4288b82492195808ffdebb98"
    sha256                               x86_64_linux:   "1f3ff8b72c1a603925afe3b89380bde7017e1e5df39b663c1c0aacc1588c7694"
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
