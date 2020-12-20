class Libgnomecanvasmm < Formula
  desc "C++ wrapper for libgnomecanvas"
  homepage "https://launchpad.net/libgnomecanvasmm"
  url "https://download.gnome.org/sources/libgnomecanvasmm/2.26/libgnomecanvasmm-2.26.0.tar.bz2"
  sha256 "996577f97f459a574919e15ba7fee6af8cda38a87a98289e9a4f54752d83e918"
  license "LGPL-2.1-or-later"
  revision 10

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "a5c94355276b754903c48790c57c18ee4c8c0f794bb7b390a93fb4474703e658" => :big_sur
    sha256 "19738b123860a54f4ca307ffcd42c0de8ff324ea0ce060c49e734bc4d0bebd26" => :catalina
    sha256 "1827d05f1125389b3786832bbb741b65a375de9d3f16554f77432ab1fca13027" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "gtkmm"
  depends_on "libgnomecanvas"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libgnomecanvasmm.h>

      int main(int argc, char *argv[]) {
        Gnome::Canvas::init();
        return 0;
      }
    EOS
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libgnomecanvasmm-2.6"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
