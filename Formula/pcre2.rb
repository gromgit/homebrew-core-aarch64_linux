class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  license "BSD-3-Clause"
  revision 1

  # Remove `stable` block next release when patches are no longer needed
  stable do
    url "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-10.38/pcre2-10.38.tar.bz2"
    sha256 "7d95aa7c8a7b0749bf03c4bd73626ab61dece7e3986b5a57f5ec39eebef6b07c"

    # fix incorrect detection of alternatives in first character search with JIT
    # remove in the next release
    patch do
      url "https://github.com/PhilipHazel/pcre2/commit/51ec2c9893e7dac762b70033b85f55801b01176c.patch?full_index=1"
      sha256 "0e91049d9d2afaff3169ddf8b0d95a9cd968793f2875af8064e0ab572c594007"
    end

    # enable JIT again in Apple Silicon with 11.2+ (sljit PR zherczeg/sljit#105)
    patch :p2 do
      url "https://github.com/zherczeg/sljit/commit/d6a0fa61e09266ad2e36d8ccd56f775e37b749e9.patch?full_index=1"
      sha256 "8d699f6c8ae085f50cf8823dcfadb8591f7ad8f9aa0db9666bd126bb625d7543"
      directory "src/sljit"
    end

    # https://lists.gnu.org/archive/html/libtool-patches/2020-06/msg00001.html
    patch :p0, :DATA
  end

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ae1f05e36d3bb1d441aa3dd25cfaf19646797e946c5ee92e3895d84e12670791"
    sha256 cellar: :any,                 arm64_big_sur:  "51b0ff7dc18491f57f470b8b778b3fa148def0dbcafac6e828a68822cb4e203b"
    sha256 cellar: :any,                 monterey:       "02aea26dba4a50219be0d1d6a377641fb7716c64bf9d40062ffcb90f3cba461d"
    sha256 cellar: :any,                 big_sur:        "951e867aec8212de345e44ecae231964a81d9a9b7033b9b43ca74cf41ac43408"
    sha256 cellar: :any,                 catalina:       "20867bbc297f9419aff9e752f79bf973758a223063d012fc28016e47239bd54b"
    sha256 cellar: :any,                 mojave:         "74b92c04402808c96f7a42c5dc5a86331e29e81ac9a1fb2f01e3332de4f3d8d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d26eb6c1d717c081bfa455825c1edca3230c4f007f4334d207bb72ee727c9ff8"
  end

  head do
    url "https://github.com/PhilipHazel/pcre2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
      --enable-jit
    ]

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end

__END__
--- configure.orig	2021-10-01 08:15:08.000000000 -0700
+++ configure	2021-10-20 12:44:47.000000000 -0700
@@ -8733,16 +8733,11 @@
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[91]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[012][,.]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[012],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
