class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2021.04/rakudo-2021.04.tar.gz"
  sha256 "6a5105d619d5e9fe8c3699dc331fc0efd32f6786de55b3cf0f438cd59e44e38e"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "3bd6655f7515bb3377031387f862eec4011dca90b1459091749224b668e4b9ac"
    sha256 big_sur:       "0fd2bf4f14062c986cff5d327d3d4c2cd7d0ee26ab5b4d3fe236050402e9aed4"
    sha256 catalina:      "0485dd2f40f4cc83f4755751bb30d02b8d34a84512f57cf3c1a9a8880b32f17f"
    sha256 mojave:        "fe75fa9fedb267ee094d278cfc23564dd221a4dc8a3f470effb5c6d4d305f59d"
  end

  depends_on "nqp"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.p6" => "perl6-install-dist"
  end

  test do
    out = shell_output("#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
