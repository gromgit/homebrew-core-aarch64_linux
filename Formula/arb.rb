class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "https://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.23.0.tar.gz"
  sha256 "977d41bde46f5442511d5165c705cec32c03e852c84d7d1836135d412ce702bb"
  license "LGPL-2.1-or-later"
  head "https://github.com/fredrik-johansson/arb.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/arb"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "339d99fcc4e839b4d8a3a7e02b0bab31810d9302d1b1664f4a80648974750626"
  end


  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <arb.h>

      int main()
      {
          slong prec;
          arb_t x, y;
          arb_init(x); arb_init(y);

          for (prec = 64; ; prec *= 2)
          {
              arb_const_pi(x, prec);
              arb_set_si(y, -10000);
              arb_exp(y, y, prec);
              arb_add(x, x, y, prec);
              arb_sin(y, x, prec);
              if (arb_rel_accuracy_bits(y) >= 53) {
                  arb_printn(y, 15, 0); printf("\\n");
                  break;
              }
          }

          arb_clear(x); arb_clear(y);
          flint_cleanup();
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["flint"].opt_include}",
           "-L#{lib}", "-L#{Formula["flint"].opt_lib}",
           "-larb", "-lflint", "-o", "test"
    assert_match %r{\[-?\d+\.\d+e-\d+ \+/- \d+\.\d+e-\d+\]}, shell_output("./test")
  end
end
