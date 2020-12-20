class XcbUtilKeysyms < Formula
  desc "Standard X constants and conversion to/from keycodes"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2"
  sha256 "0ef8490ff1dede52b7de533158547f8b454b241aa3e4dcca369507f66f216dd9"
  license "X11"

  depends_on "pkg-config" => [:build, :test]
  depends_on "util-macros" => :build
  depends_on "libxcb"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-keysyms").chomp
  end
end
