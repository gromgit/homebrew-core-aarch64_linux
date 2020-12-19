class Libglademm < Formula
  desc "C++ wrapper around libglade"
  homepage "https://gnome.org"
  url "https://download.gnome.org/sources/libglademm/2.6/libglademm-2.6.7.tar.bz2"
  sha256 "38543c15acf727434341cc08c2b003d24f36abc22380937707fc2c5c687a2bc3"
  license "LGPL-2.1-or-later"
  revision 10

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "8275875bd6c02dd8d34e138ff152e1d3b20a7d96b32e5e8f8055bca603f0a17f" => :big_sur
    sha256 "bc1a20f5266861e5f053a6bb2b4f1deee115cded38370ed22dacb1e66c32ed53" => :catalina
    sha256 "5b559cc66165130ca89c2b3117366e559f65bfde3b4b6dc2a42370f68aaa52b8" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "gtkmm"
  depends_on "libglade"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libglademm.h>

      int main(int argc, char *argv[]) {
        try {
          throw Gnome::Glade::XmlError("this formula should die");
        }
        catch (Gnome::Glade::XmlError &e) {}
        return 0;
      }
    EOS
    ENV.libxml2
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libglademm-2.4").strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
