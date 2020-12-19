class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.9.tar.xz"
  sha256 "fc3202bddf2ebbb93ffd31fc2a079cfc05957e4bf219535f26e6d8784d859e9b"
  license "GPL-2.0-or-later"
  revision 7

  livecheck do
    url :stable
  end

  bottle do
    sha256 "bdcc8e8a29554fa2044a43ee87b0719c4cfcbc29f6704ca627baf33cf64a6cd7" => :big_sur
    sha256 "cd5e8a3bf6d9cdc08dcb9f22b9980f8e6171ee6ae6a7ec7efea7cd0f7828cdf1" => :catalina
    sha256 "e2292a094523141912e01fe8432833637439bbf7a2111187135f7d96934aa8a4" => :mojave
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtkmm3"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/prefixsuffix", "--version"
  end
end
