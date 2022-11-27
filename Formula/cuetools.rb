class Cuetools < Formula
  desc "Utilities for .cue and .toc files"
  homepage "https://github.com/svend/cuetools"
  url "https://github.com/svend/cuetools/archive/1.4.1.tar.gz"
  sha256 "24a2420f100c69a6539a9feeb4130d19532f9f8a0428a8b9b289c6da761eb107"
  license "GPL-2.0"
  head "https://github.com/svend/cuetools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cuetools"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ee00ce79c6fbf2ad64db87a9bc4b5a5943029d1031edb19465b9912406796520"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # see https://github.com/svend/cuetools/pull/18
  patch :DATA

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.cue").write <<~EOS
      FILE "sampleimage.bin" BINARY
        TRACK 01 MODE1/2352
          INDEX 01 00:00:00
    EOS
    system "cueconvert", testpath/"test.cue", testpath/"test.toc"
    assert_predicate testpath/"test.toc", :exist?
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index f54bb92..84ab467 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,5 @@
 AC_INIT([cuetools], [1.4.0], [svend@ciffer.net])
-AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+AM_INIT_AUTOMAKE([-Wall -Werror -Wno-extra-portability foreign])
 AC_PROG_CC
 AC_PROG_INSTALL
 AC_PROG_RANLIB
