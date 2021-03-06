class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.1/libadwaita-1.1.1.tar.xz"
  sha256 "491169d4f6a11765328996bc088272d05c7235453bc0ee73c20dfd4bd67b401c"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "5c6234832fe8d366f2050cef5954a11e00c2d8723c15b8c11ad6ab5aa4e63000"
    sha256 arm64_big_sur:  "6036c1f23448039f0e716db5acc98a8c2e8886b87f8fbf0a98e92709eac3c621"
    sha256 monterey:       "7a55dff30538fc820c1002c26d57ea9c5e79650c6c65cfd65c12662bfc4b532f"
    sha256 big_sur:        "ab60d5de5b3c1d9957d06a2e4f11662fb541af8e4b1e28411c790325fa478918"
    sha256 catalina:       "1f7fef555d61730f4a5829d61451a8fb78168e29b66d66c624f69f167f70f6b8"
    sha256 x86_64_linux:   "ddaf7ea295e44050179461ecac915fc0435a3427c77df71d329ca7c154a037ef"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sassc" => :build
  depends_on "vala" => :build
  depends_on "gtk4"

  def install
    args = std_meson_args + %w[
      -Dtests=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_FLAGS_NONE);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end
