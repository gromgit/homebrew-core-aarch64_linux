class Libxpm < Formula
  desc "X.Org: X Pixmap (XPM) image file format library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXpm-3.5.12.tar.bz2"
  sha256 "fd6a6de3da48de8d1bb738ab6be4ad67f7cb0986c39bd3f7d51dd24f7854bdec"
  license "MIT"

  bottle do
    cellar :any
    sha256 "53865d3b3d752c71525a40db99851580b5d979f7b722b0bf361d923e33a39ea5" => :catalina
    sha256 "9b34b6b7ca85c9e0082b823d31e82094c5b7106e7d3af1e8cba33fc994b54382" => :mojave
    sha256 "32c76e168d128d34dea14d51c422888fab28c3db1ecad10fc5bd457afe239b8a" => :high_sierra
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libx11"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/xpm.h"

      int main(int argc, char* argv[]) {
        XpmColor color;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
