class Libmpc < Formula
  desc "C library for the arithmetic of high precision complex numbers"
  homepage "http://www.multiprecision.org/mpc/"
  url "https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/mpc/mpc-1.2.1.tar.gz"
  sha256 "17503d2c395dfcf106b622dc142683c1199431d095367c6aacba6eec30340459"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "94f1002674d74f582bf3d87079c2b3ddbb4b6add13d4bd7b522acd7bda419bba" => :catalina
    sha256 "5896218dabc22de4582cde53ce464263a6675eece309f52c6a262b02e5b6dc60" => :mojave
    sha256 "b48ea39caa145b937b7158c73218e2d98f045bbb6186b48eb1873f45e6a51dea" => :high_sierra
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
