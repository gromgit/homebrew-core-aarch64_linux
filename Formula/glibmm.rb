class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.68/glibmm-2.68.0.tar.xz"
  sha256 "c1f38573191dceed85a05600888cf4cf4695941f339715bd67d51c2416f4f375"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "2b59ddf120e572ee7600511d68ad28d88d1c4c8bdbb4433f4130c1d6ad36535f" => :big_sur
    sha256 "538ea9ae420f05283f041810043dfcce832c55b1cd122b61be53a2e5113cfb93" => :catalina
    sha256 "cff366a7acaed3ac8804fc94431b4b6c840d47a82da0e0d1eb2133caaa1fb96c" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++"

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.68
      -I#{libsigcxx.opt_include}/sigc++-3.0
      -I#{libsigcxx.opt_lib}/sigc++-3.0/include
      -I#{lib}/glibmm-2.68/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.68
      -lgobject-2.0
      -lintl
      -lsigc-3.0
    ]
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
