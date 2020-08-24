class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.08/MoarVM-2020.08.tar.gz"
  sha256 "3ede5e70352885e596b505a8ec6bd302513527578a077102886a5a5a3ef907bf"
  license "Artistic-2.0"

  bottle do
    sha256 "e0c39e3ee08d26eee62ab00a11fb751e36e8739d3eb896e58992e38ed5c0c14f" => :catalina
    sha256 "71fa477b3d249386cfe445de25eeff31ee9b7b8f051c775d5d9a90ea10e16fbf" => :mojave
    sha256 "e90e3a2106f9f780d5fdd75a40ad8ef01970f23e14b20094607da3f48a1c296c" => :high_sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/perl6/nqp/releases/download/2020.08/nqp-2020.08.tar.gz"
    sha256 "a2b68c112adeb11e9ead3f63aa83249821d4c4b23d5f7c35c9effbafb2b4a128"
  end

  def install
    libffi = Formula["libffi"]
    ENV.prepend "CPPFLAGS", "-I#{libffi.opt_lib}/libffi-#{libffi.version}/include"
    configure_args = %W[
      --has-libatomic_ops
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
      --prefix=#{prefix}
    ]
    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
