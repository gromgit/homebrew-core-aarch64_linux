class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  license "GPL-3.0-or-later"

  stable do
    url "http://www.greenwoodsoftware.com/less/less-563.tar.gz"
    sha256 "ce5b6d2b9fc4442d7a07c93ab128d2dff2ce09a1d4f2d055b95cf28dd0dc9a9a"

    # Fix build with Xcode 12 as it no longer allows implicit function declarations
    # See https://github.com/gwsw/less/issues/91
    patch :DATA
  end

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+).+?released.+?general use/i)
  end

  bottle do
    cellar :any
    sha256 "78e78c03cfa593c7a8d8d082dd9d1b3f5ba742828d75c362fa0a69904349337f" => :big_sur
    sha256 "a9964d5cb1b7b86e7c6b734c59931f76dd1a5e8c6caaab727936de976e3f10c4" => :catalina
    sha256 "745421ab0d0226624ca632d8db1e63c7f5063be53da579db909d3079964c8113" => :mojave
    sha256 "e9fe8e7982ddfb6e4c3ab5c5cc9e90a8190a61ffbb8afcd7cb95ea49523a44db" => :high_sierra
  end

  head do
    url "https://github.com/gwsw/less.git"
    depends_on "autoconf" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "pcre"

  uses_from_macos "ncurses"

  def install
    system "make", "-f", "Makefile.aut", "dist" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
__END__
diff --git a/configure b/configure
index 0ce6db1..eac7ca0 100755
--- a/configure
+++ b/configure
@@ -4104,11 +4104,11 @@ if test "x$TERMLIBS" = x; then
     TERMLIBS="-lncurses"
     SAVE_LIBS=$LIBS
     LIBS="$LIBS $TERMLIBS"
     cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
-
+#include <termcap.h>
 int
 main ()
 {
 tgetent(0,0); tgetflag(0); tgetnum(0); tgetstr(0,0);
   ;
