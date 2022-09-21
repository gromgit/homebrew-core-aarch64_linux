class Libmpc < Formula
  desc "C library for the arithmetic of high precision complex numbers"
  homepage "http://www.multiprecision.org/mpc/"
  license "LGPL-3.0-or-later"

  stable do
    url "https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz"
    mirror "https://ftpmirror.gnu.org/mpc/mpc-1.2.1.tar.gz"
    sha256 "17503d2c395dfcf106b622dc142683c1199431d095367c6aacba6eec30340459"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libmpc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0844027e67fd779bed17f06c9afbe3d8628268457cd766455058c625dbea2fa6"
  end

  head do
    url "https://gitlab.inria.fr/mpc/mpc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
    ]

    system "autoreconf", "-fiv" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpc.h>
      #include <assert.h>
      #include <math.h>

      int main() {
        mpc_t x;
        mpc_init2 (x, 256);
        mpc_set_d_d (x, 1., INFINITY, MPC_RNDNN);
        mpc_tanh (x, x, MPC_RNDNN);
        assert (mpfr_nan_p (mpc_realref (x)) && mpfr_nan_p (mpc_imagref (x)));
        mpc_clear (x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["mpfr"].opt_lib}",
                   "-L#{Formula["gmp"].opt_lib}", "-lmpc", "-lmpfr",
                   "-lgmp", "-o", "test"
    system "./test"
  end
end
