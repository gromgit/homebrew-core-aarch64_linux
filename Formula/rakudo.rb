class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2020.07/rakudo-2020.07.tar.gz"
  sha256 "39624de1394b3e15bba0b456afb598fb2c47c3f38528ba375bed583213f0cab8"
  license "Artistic-2.0"

  bottle do
    sha256 "80870b47549bfbee7413bd31e6027c0f538e52572fa1cf0656371480d34016e7" => :catalina
    sha256 "973ee2b4de49403c823c1ed47793cbb0ff7114efee3e457876313c4486cc4999" => :mojave
    sha256 "d44bd6000cf8003aa86d001e374ed113f98b222469b7d421baa4e751f1bfe34e" => :high_sierra
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
