class Freealut < Formula
  desc "Implementation of OpenAL's ALUT standard"
  homepage "https://github.com/vancegroup/freealut"
  url "https://deb.debian.org/debian/pool/main/f/freealut/freealut_1.1.0.orig.tar.gz"
  sha256 "60d1ea8779471bb851b89b49ce44eecb78e46265be1a6e9320a28b100c8df44f"
  license "LGPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/freealut"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1bb5279dda1f966fcf7b059aa50571882096508d03552209128b4a9b9d275fe0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Adds the OpenAL frameworks to the library list so linking succeeds
  on_macos do
    patch :DATA
  end

  on_linux do
    depends_on "openal-soft"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 2b26d6d..4001db1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -83,7 +83,8 @@ AC_DEFINE([ALUT_BUILD_LIBRARY], [1], [Define to 1 if you want to build the ALUT

 # Checks for libraries. (not perfect yet)
 AC_SEARCH_LIBS([pthread_self], [pthread])
-AC_SEARCH_LIBS([alGetError], [openal32 openal])
+# Use Mac OS X frameworks
+LIBS="$LIBS -framework IOKit -framework OpenAL"

 ################################################################################
 # Checks for header files.
