class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  # NOTE: Please keep these values in sync with nqp & rakudo when updating.
  url "https://github.com/MoarVM/MoarVM/releases/download/2021.02/MoarVM-2021.02.tar.gz"
  sha256 "19a0c3679e7be8081ddea28a02264be8a821cf624452e35977f8a4b9764d3123"
  license "Artistic-2.0"

  livecheck do
    url "https://github.com/MoarVM/MoarVM.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "cce99fb71c2e3605bd3a05df6ca700b63d41c95ea410ac32d72dc726d94683e4"
    sha256 big_sur:       "b585777c5b31b6d7865fcb389bc694ad86b48e1dc15b29e34bec61183f17004c"
    sha256 catalina:      "a93ea32a0ccf20cf05300ff1c06edc93de3679b3c70503e84a627c3ffdaba14e"
    sha256 mojave:        "e3f3ed409f05c8d38046a3a0c18c35d2d1e89fdb8369420814f7de91ca6f3997"
  end

  depends_on "libatomic_ops"
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2021.02/nqp-2021.02.tar.gz"
    sha256 "d24b1dc8c9f5e743787098a19c9d17b75f57dd34d293716d5b15b9105037d4ef"
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
