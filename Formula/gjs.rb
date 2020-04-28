class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.64/gjs-1.64.2.tar.xz"
  sha256 "15ff834d374df19595d955f03e6b60631a3bb14fabda36d00f81ab3eabd3997b"

  bottle do
    sha256 "d58cd5acc39ad9282779dfbe2cff82f89053070a5c56cbe9094b9b8959e37e2b" => :catalina
    sha256 "5a4f3fc63abf09a5994630dd62174efba62e6e22d7bea1520fe7a4de1fe8d68c" => :mojave
    sha256 "be451da8dd0df26a949218d66ef3f4d02d48661f036c99019717afc2a815d2d0" => :high_sierra
  end

  depends_on "autoconf@2.13" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "llvm"
  depends_on "nspr"
  depends_on "readline"

  resource "mozjs68" do
    url "https://archive.mozilla.org/pub/firefox/releases/68.5.0esr/source/firefox-68.5.0esr.source.tar.xz"
    sha256 "52e784f98a37624e8b207f1b23289c2c88f66dd923798cae891a586a6d94a6d1"
  end

  def install
    ENV.cxx11
    ENV["_MACOSX_DEPLOYMENT_TARGET"] = ENV["MACOSX_DEPLOYMENT_TARGET"]

    resource("mozjs68").stage do
      inreplace "config/rules.mk",
                "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
                "-install_name #{lib}/$(SHARED_LIBRARY) "
      inreplace "old-configure", "-Wl,-executable_path,${DIST}/bin", ""
      inreplace "build/moz.configure/toolchain.configure",
                "sdk_max_version = Version('10.14')",
                "sdk_max_version = Version('10.16')"

      mkdir("build") do
        ENV["PYTHON"] = "python"
        system "../js/src/configure", "--prefix=#{prefix}",
                              "--with-system-nspr",
                              "--with-system-zlib",
                              "--with-system-icu",
                              "--enable-readline",
                              "--enable-shared-js",
                              "--enable-optimize",
                              "--enable-release",
                              "--with-intl-api",
                              "--disable-jemalloc",
                              "--disable-xcode-checks"
        system "make"
        system "make", "install"
        rm Dir["#{bin}/*"]
      end
      # headers were installed as softlinks, which is not acceptable
      cd(include.to_s) do
        `find . -type l`.chomp.split.each do |link|
          header = File.readlink(link)
          rm link
          cp header, link
        end
      end
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      rm "#{lib}/libjs_static.ajs"
    end

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    args = %W[
      --prefix=#{prefix}
      -Dprofiler=disabled
      -Dinstalled_tests=false
      -Dbsymbolic_functions=false
      -Dskip_dbus_tests=true
      -Dskip_gtk_tests=true
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.js").write <<~EOS
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
      if (31 != GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
        imports.system.exit(1)
    EOS
    system "#{bin}/gjs", "test.js"
  end
end
