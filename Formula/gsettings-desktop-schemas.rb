class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.38/gsettings-desktop-schemas-3.38.0.tar.xz"
  sha256 "5704c8266004b296036671f223c705dc046aa694a1b1abb87c67e7d2747a8c67"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ca79e0409fb9d658c9ab2f9e3ecde89e10ef305121b9fa71c909cf3cb098a82a" => :catalina
    sha256 "ca79e0409fb9d658c9ab2f9e3ecde89e10ef305121b9fa71c909cf3cb098a82a" => :mojave
    sha256 "ca79e0409fb9d658c9ab2f9e3ecde89e10ef305121b9fa71c909cf3cb098a82a" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  uses_from_macos "expat"

  def install
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end
