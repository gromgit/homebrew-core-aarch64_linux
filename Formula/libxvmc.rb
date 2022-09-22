class Libxvmc < Formula
  desc "X.Org: X-Video Motion Compensation API"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXvMC-1.0.13.tar.xz"
  sha256 "0a9ebe6dea7888a747e5aca1b891d53cd7d3a5f141a9645f77d9b6a12cee657c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libxvmc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a7eae09b648a2228745b3a1dd515d472e9ef8de17c217dd627a5b986ded01977"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxv"

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
      #include "X11/extensions/XvMClib.h"

      int main(int argc, char* argv[]) {
        XvPortID *port_id;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
