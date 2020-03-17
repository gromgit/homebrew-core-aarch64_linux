class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.64/glibmm-2.64.0.tar.xz"
  sha256 "46e83d4a123e41784b3b04a7cdcfcdaf918ba8e7e05b2acb10be0e0c09883c12"

  bottle do
    cellar :any
    sha256 "9dd137d8cee10a3604a20c0c5318db7e9fb68e49328727d4b712589c8293d1a7" => :catalina
    sha256 "161bab6c21bb5137f9c4603b0f6873cc3a8b30bfbfcdf49bb30812d070ebdfb1" => :mojave
    sha256 "df7fe42bb76f0b9ca5b9e17a1dfde4419d8c99a92e11a3c1237be1d9e6795449" => :high_sierra
    sha256 "f658b7bdcf4888b849b06d10c0c9686a8f624ceefec5579921f265f561d0076f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++@2"

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++@2"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
