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
    sha256 "6189310fa33df4999a0b8b0842db2201d271b75f9a73f06d7df5ccbb00edb0e0" => :big_sur
    sha256 "ae269c474d133b08e9d7e86fcf28fbe57cafa6e7d40915697a4fb1254e59e21e" => :catalina
    sha256 "45f6ba28c7ce893d66908e6fbc35381209160fba54b94811efa4ade6e915eeba" => :mojave
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
