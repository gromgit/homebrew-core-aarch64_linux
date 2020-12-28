class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  # NOTE: Please keep these values in sync with moarvm & nqp when updating.
  url "https://github.com/rakudo/rakudo/releases/download/2020.12/rakudo-2020.12.tar.gz"
  sha256 "c7ccfbb832b97607282d2cd4747e68522e522fe254e329a869053145218f6cbc"
  license "Artistic-2.0"

  bottle do
    sha256 "83076a1b58459f6a0e491f4346002d99ebec4bbe7930ed2768ac49d356878bb0" => :big_sur
    sha256 "037e2f8a092fba323ac8aa8356c2623902284e3bd281d48187e4b135f487b146" => :arm64_big_sur
    sha256 "52360ea3f95f2bf105d09733a6ba6bd4f3f0664ac3e838e3b21020020dcd1d52" => :catalina
    sha256 "b2cef9b265ce3245062cb4bc92eced599807104f63f918bab1a22605de2828a9" => :mojave
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
