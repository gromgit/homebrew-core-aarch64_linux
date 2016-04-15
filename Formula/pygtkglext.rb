class Pygtkglext < Formula
  desc "Python bindings to OpenGL GTK+ extension"
  homepage "https://projects.gnome.org/gtkglext/download.html#pygtkglext"
  url "https://download.gnome.org/sources/pygtkglext/1.1/pygtkglext-1.1.0.tar.gz"
  sha256 "9712c04c60bf6ee7d05e0c6a6672040095c2ea803a1546af6dfde562dc0178a3"
  revision 1

  bottle do
    sha256 "f7300b52df0a015cc86269908b6c23887eb11a7700b40ebd6e2671c2565fb3a2" => :el_capitan
    sha256 "abbda3f7a801b6b620e9ca77c009b3e3ff3dd2898d8969a8e8148161e38190be" => :yosemite
    sha256 "afe62336baf3fb7ad52dfe7cd181419a30224dbeb126d77b186fa1600812e81a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "pygtk"
  depends_on "gtkglext"
  depends_on "pygobject"

  def install
    ENV["PYGTK_CODEGEN"] = "#{Formula["pygobject"].opt_bin}/pygobject-codegen-2.0"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "python", "-c", "import pygtk", "pygtk.require('2.0')", "import gtk.gtkgl"
  end
end
