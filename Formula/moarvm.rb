class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.07/MoarVM-2020.07.tar.gz"
  sha256 "da48887a1be0e397586b3470c2627d04c64d1e0caf9305ee7dc8db8db739f7cf"

  bottle do
    sha256 "c72de5db670e00640c9d275c44d0450d5aba135941736db72f556db2a58986fc" => :catalina
    sha256 "c7d5df8a6b997858d47fbbc7fced224b54054b632e4c651d51bdb208cf806bec" => :mojave
    sha256 "b70cdc02c5da86e7d59d4fb636e3bddb9006ba88d744c5d3fb0b3a24b8fa00cc" => :high_sierra
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", :because => "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/perl6/nqp/releases/download/2020.05/nqp-2020.05.tar.gz"
    sha256 "291b92d9db968a691195adb1c9533edc1076d12d6617d6d931e40595e906b577"
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
