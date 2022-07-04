class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.92.tar.xz"
  sha256 "f667735028944b6375ad18f160a64ceb93f5c7dccaa9d8751de359777488a2c1"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_monterey: "33d2559001ddbc2cc4063a36243d63d5a3bedbde4735259473248c54f661f9bd"
    sha256                               arm64_big_sur:  "bcb2fdea80e000e6c464926068e118f62f853863e95a8e10d74d31abfa9ddd03"
    sha256                               monterey:       "4720fb8e970fc98ca17f5e16606d56c4198015beb7569a6cd54ed5213e760a65"
    sha256                               big_sur:        "4835558673e20b770f9d86e4be991e5cf3e28b9796a5f4f687a8a202834a37d5"
    sha256                               catalina:       "193b0672fc31c02feb32100f3bfcdeb130877e65bbc96b874df2d50b4ac3c562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de13877cc45551c2c7e037401f9339a2bdc243ca134412dca77ac851c468674"
  end

  depends_on "glib" => :build # for gobject-introspection
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

  # https://gitlab.gnome.org/GNOME/babl/-/merge_requests/45
  # Can be removed on next version
  patch do
    url "https://gitlab.gnome.org/GNOME/babl/-/commit/b05b2826365a7dbc6ca1bf0977b848055cd0cbb6.diff"
    sha256 "e428f1f11ee1456f4b630c193dca7448059c160418cccbd0ec1d28105db7bfc6"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith-docs=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <babl/babl.h>
      int main() {
        babl_init();
        const Babl *srgb = babl_format ("R'G'B' u8");
        const Babl *lab  = babl_format ("CIE Lab float");
        const Babl *rgb_to_lab_fish = babl_fish (srgb, lab);
        babl_exit();
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/babl-0.1", testpath/"test.c", "-L#{lib}", "-lbabl-0.1", "-o", "test"
    system testpath/"test"
  end
end
