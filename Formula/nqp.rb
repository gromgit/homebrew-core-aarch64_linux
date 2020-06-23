class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2020.06/nqp-2020.06.tar.gz"
  sha256 "a49e3374cf628d845043b50d192d36131adf0ab91e7e0795a1dc20dd7b83938f"

  bottle do
    sha256 "e5fed6211e4c2923526d88fd83a6e49ccf5eb6994c6b6cc465aa2762750c0239" => :catalina
    sha256 "e50bef373949fbc54f82d6ab8a24f83fff9dc9f8faaa1dc5c33113c1a31277eb" => :mojave
    sha256 "2584ab57c5fd7f37cfee93e4f37da2ecd0b24adae41b1e77da1fbc0d43d56348" => :high_sierra
  end

  depends_on "moarvm"

  conflicts_with "rakudo-star", :because => "rakudo-star currently ships with nqp included"

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
