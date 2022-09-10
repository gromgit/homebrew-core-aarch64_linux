class Libxi < Formula
  desc "X.Org: Library for the X Input Extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXi-1.8.tar.bz2"
  sha256 "2ed181446a61c7337576467870bc5336fc9e222a281122d96c4d39a3298bba00"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libxi"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "02b64786e8f5addd2845c5993017309dc0e11dd7ab4b5255c971471b2270f130"
  end


  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "xorgproto"

  conflicts_with "libslax", because: "both install `libxi.a`"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/XInput.h"

      int main(int argc, char* argv[]) {
        XDeviceButtonEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
