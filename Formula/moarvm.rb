class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  # NOTE: Please keep these values in sync with nqp & rakudo when updating.
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.12/MoarVM-2020.12.tar.gz"
  sha256 "08914f1c464151ebc678cf0d360c9e479a036178fa7c9ddfd34aa4d556d03ea2"
  license "Artistic-2.0"

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "c9728c1e0b77e7a68f3ac5689975c28c72da6860ca7b55b099244e9256cff32d" => :big_sur
    sha256 "373260b1859ec90ea268a6440a02dec0fb6248e3d0f93424062773f0e71cdf03" => :arm64_big_sur
    sha256 "91c1103370b2d7c9a0831fa448c50a97c63c4c0cad174fdfca4cf90cdc43fa02" => :catalina
    sha256 "7a7249de788c78bf75163989db13f32d7da4db49747f58d9210766e206ffb773" => :mojave
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/perl6/nqp/releases/download/2020.12/nqp-2020.12.tar.gz"
    sha256 "fd445b3c3b844a2fc523dc567b2a65c4dc2cc9a3f42ef2e860ef71174823068e"
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
