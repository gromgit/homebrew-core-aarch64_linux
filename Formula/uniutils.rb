class Uniutils < Formula
  desc "Manipulate and analyze Unicode text"
  homepage "https://billposer.org/Software/unidesc.html"
  url "https://billposer.org/Software/Downloads/uniutils-2.27.tar.gz"
  sha256 "c662a9215a3a67aae60510f679135d479dbddaf90f5c85a3c5bab1c89da61596"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(/href=.*?uniutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/uniutils"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8de161626d46038d19429f792ea3d598e180a0c189429602d7ed1d5d65ffe3d2"
  end

  # Allow build with clang. This patch was reported to debian here:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=740968
  # And emailed to the upstream source at billposer@alum.mit.edu
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    s = pipe_output("#{bin}/uniname", "ü")
    assert_match "LATIN SMALL LETTER U WITH DIAERESIS", s
  end
end

__END__
Description: Fix clang FTBFS [-Wreturn-type]
Author: Nicolas Sévelin-Radiguet <nicosr@free.fr>
Last-Update: 2014-03-06
--- a/unifuzz.c
+++ b/unifuzz.c
@@ -97,7 +97,7 @@
 }

 /* Emit the middle character from each range */
-EmitAllRanges(short AboveBMPP) {
+void EmitAllRanges(short AboveBMPP) {
   int i;
   UTF32 scp;
   extern int Ranges_Defined;
