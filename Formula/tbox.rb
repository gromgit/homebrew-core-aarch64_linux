class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.6.5.tar.gz"
  sha256 "076599f8699a21934f633f1732977d0df9181891ca982fd23ba172047d2cf4ab"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a1465af2674967d3a913d23a2adbbf8d84eb1eaf2d8c76e590c736166fda196c" => :big_sur
    sha256 "efbd3cb9e04bdc66b5a25a24be957be60589fb902357fa13d1efb832160c2f55" => :arm64_big_sur
    sha256 "ce40f3f45a981856840999da154f1ec53f63457824e6e664327afae62a79a38f" => :catalina
    sha256 "32a54a4715e25302a9e908c345a0021d272d4ab78d989f7f6343207da974f25a" => :mojave
  end

  depends_on "xmake" => :build

  def install
    system "xmake", "config", "--charset=y", "--demo=n", "--small=y", "--xml=y"
    system "xmake"
    system "xmake", "install", "-o", prefix
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tbox/tbox.h>
      int main()
      {
        if (tb_init(tb_null, tb_null))
        {
          tb_trace_i("hello tbox!");
          tb_exit();
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltbox", "-I#{include}", "-o", "test"
    system "./test"
  end
end
