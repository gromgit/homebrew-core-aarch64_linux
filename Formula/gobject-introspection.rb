class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.64/gobject-introspection-1.64.0.tar.xz"
  sha256 "eac05a63091c81adfdc8ef34820bcc7e7778c5b9e34734d344fc9e69ddf4fc82"

  bottle do
    sha256 "0617abce4097de602c1b3baf28619c963ce977051908ffc7f75067e75300d92c" => :catalina
    sha256 "477a83958b0ffc54a036e01a24f9a817f39c587b4eed31195bba26304f00c7b0" => :mojave
    sha256 "910c77c66a2dc44ccadb1ac3b5bd3175b79eaccc65dbefe8907947292aa49fb6" => :high_sierra
    sha256 "18094c0984efb6bfbdd0ada1c7954df1e5041bbcb0191694789dc96976bcdf69" => :sierra
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"
  depends_on "python"

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    args = %W[
      --prefix=#{prefix}
      -Dpython=#{Formula["python"].opt_bin}/python3
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
