class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.9.tar.xz"
  sha256 "fc3202bddf2ebbb93ffd31fc2a079cfc05957e4bf219535f26e6d8784d859e9b"
  license "GPL-2.0-or-later"
  revision 8

  livecheck do
    url :stable
  end

  bottle do
    sha256 "15de04984c558fc657406c078463e50010b995b55faa28797d5b751c1c61fe69" => :big_sur
    sha256 "8de52a170c24c34d11d3dfdeeacc3274c9365aa3988cd448acbcdba86b0f30bd" => :catalina
    sha256 "849354e6d09e1d57965b32056c49c067712c2775c8391de9ab7330d4e6801ba1" => :mojave
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
