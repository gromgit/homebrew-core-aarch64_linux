class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/perl6/nqp/releases/download/2020.12/nqp-2020.12.tar.gz"
  sha256 "fd445b3c3b844a2fc523dc567b2a65c4dc2cc9a3f42ef2e860ef71174823068e"
  license "Artistic-2.0"

  bottle do
    sha256 "7532b02608b579edb4adf02dca2569cfad4aeecbb5c10a0949b02b71252fbd25" => :big_sur
    sha256 "865d04f5c0514f991155973a4edd75c8767b3afbb4f996d0823b90958796d3d7" => :arm64_big_sur
    sha256 "55d917153481171c3d955bec4a2724748a8957889111aaf523672a78a1632564" => :catalina
    sha256 "93957544005becea32a6ab558ada80781cd5600fb4fe7319e198be0d84664a6d" => :mojave
  end

  depends_on "moarvm"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
