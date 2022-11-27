class Aggregate < Formula
  desc "Optimizes lists of prefixes to reduce list lengths"
  homepage "https://web.archive.org/web/20160716192438/freecode.com/projects/aggregate/"
  url "https://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz"
  sha256 "166503005cd8722c730e530cc90652ddfa198a25624914c65dffc3eb87ba5482"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aggregate"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e368e735082597a3129c76ae947e2d3c8ad7283b71ef04329604f0519d61ec02"
  end

  conflicts_with "crush-tools", because: "both install an `aggregate` binary"

  def install
    bin.mkpath
    man1.mkpath

    # Makefile doesn't respect --mandir or MANDIR
    inreplace "Makefile.in", "$(prefix)/man/man1", "$(prefix)/share/man/man1"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"
  end

  test do
    # Test case taken from here: https://horms.net/projects/aggregate/examples.shtml
    test_input = <<~EOS
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/24
      10.1.1.0/24
      10.1.2.0/24
      10.1.2.0/25
      10.1.2.128/25
      10.1.3.0/25
    EOS

    expected_output = <<~EOS
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/23
      10.1.2.0/24
      10.1.3.0/25
    EOS

    assert_equal expected_output, pipe_output("#{bin}/aggregate", test_input), "Test Failed"
  end
end
