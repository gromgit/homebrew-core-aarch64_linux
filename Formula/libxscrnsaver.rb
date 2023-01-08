class Libxscrnsaver < Formula
  desc "X.Org: X11 Screen Saver extension client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXScrnSaver-1.2.4.tar.xz"
  sha256 "75cd2859f38e207a090cac980d76bc71e9da99d48d09703584e00585abc920fe"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libxscrnsaver"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5d862b859003331213ff6e0ab8ea092ebdd9c3bfc9d78e018ee392e24f84a714"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

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
      #include "X11/extensions/scrnsaver.h"

      int main(int argc, char* argv[]) {
        XScreenSaverNotifyEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
