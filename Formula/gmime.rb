class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://spruce.sourceforge.io/gmime/"
  url "https://download.gnome.org/sources/gmime/3.2/gmime-3.2.7.tar.xz"
  sha256 "2aea96647a468ba2160a64e17c6dc6afe674ed9ac86070624a3f584c10737d44"

  bottle do
    sha256 "a963df8170c33605b98c42ea70f320f14738874c4cc5f4b2190affa7b856f44b" => :catalina
    sha256 "9e6b3163fe09a1062ac8eea6433f181499b892190209a9a021805331663f067d" => :mojave
    sha256 "3bb7b7e8b38db886d05e7f46bbb8deb4008379cd39bcc4ac08d1d924ba4b1b49" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gpgme"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-largefile
      --disable-vala
      --disable-glibtest
      --enable-crypto
      --enable-introspection
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <gmime/gmime.h>
      int main (int argc, char **argv)
      {
        g_mime_init();
        if (gmime_major_version>=3) {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gmime-3.0
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgmime-3.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
