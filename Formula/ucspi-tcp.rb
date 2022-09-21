class UcspiTcp < Formula
  desc "Tools for building TCP client-server applications"
  homepage "https://cr.yp.to/ucspi-tcp.html"
  url "https://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz"
  sha256 "4a0615cab74886f5b4f7e8fd32933a07b955536a3476d74ea087a3ea66a23e9c"

  livecheck do
    url "https://cr.yp.to/ucspi-tcp/install.html"
    regex(/href=.*?ucspi-tcp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ucspi-tcp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "00ef3425d3be0ac5f4f9555de532ef33c5ada1e1202b80d831e758c71efefe20"
  end

  # IPv6 patch
  # Used to be https://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.diff19.bz2
  patch do
    url "https://raw.githubusercontent.com/homebrew/patches/2b3e4da/ucspi-tcp/patch-0.88-ipv6.diff"
    sha256 "c2d6ce17c87397253f298cc28499da873efe23afe97e855bdcf34ae66374036a"
  end

  def install
    # Work around build error from root requirement: "Oops. Your getgroups() returned 0,
    # and setgroups() failed; this means that I can't reliably do my shsgr test. Please
    # either ``make'' as root or ``make'' while you're in one or more supplementary groups."
    inreplace "Makefile", "( cat warn-shsgr; exit 1 )", "cat warn-shsgr" if OS.linux?

    (buildpath/"conf-home").unlink
    (buildpath/"conf-home").write prefix

    system "make"
    bin.mkpath
    system "make", "setup"
    system "make", "check"
    share.install prefix/"man"
  end

  test do
    assert_match(/usage: tcpserver/,
      shell_output("#{bin}/tcpserver 2>&1", 100))
  end
end
