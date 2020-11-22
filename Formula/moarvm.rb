class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  # NOTE: Please keep these values in sync with nqp & rakudo when updating.
  url "https://github.com/MoarVM/MoarVM/releases/download/2020.11/MoarVM-2020.11.tar.gz"
  sha256 "6d028273b6ed5ba7b972e7b3f2681ce1deff1897ebdf7bcd5cfcd1e7c2fec384"
  license "Artistic-2.0"

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "594d181a78097b848f2a488eb25f3a9274b12f54bdc546cc165c741e617df0ba" => :big_sur
    sha256 "f012d9ed40ea2ee121057fbf07799a5bec307d0af7524c2d973d30a32c8fcced" => :catalina
    sha256 "c478335cb67dd1c5388c20abebafb7174a3280687dd6cb4c2b9d022f7c9b1736" => :mojave
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/perl6/nqp/releases/download/2020.11/nqp-2020.11.tar.gz"
    sha256 "7985f587c43801650316745f055cb5fc3f9063c5bb34de5ae695d76518ad900f"
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
