class Bgpq3 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "http://snar.spb.ru/prog/bgpq3/"
  url "https://github.com/snar/bgpq3/archive/v0.1.36.tar.gz"
  sha256 "39cefed3c4f46b07bdcb817d105964f17a756b174a3c1d3ceda26ed00ecae456"
  license "BSD-2-Clause"
  head "https://github.com/snar/bgpq3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8007ef3e5542b067d4684b88e1ac509d2bc8566ba85536235070081dba0994f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "4550c91dd5daeaf0320c7b678ffd68c5d5fc3d611857f5dcb4fe9b7130e3f439"
    sha256 cellar: :any_skip_relocation, catalina:      "428a0dcb0af2876c03374236ee10b2385ab993dc54cc12e080198d7e552bbdea"
    sha256 cellar: :any_skip_relocation, mojave:        "a16c482aa8e1a821d6747b2871174109ccbcf407e5799794f6307303fcffafcb"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2bf730bec0bca51bd9a3db7a3cd5e4bf36199717a8190db270a5f4751bb1a5e1"
    sha256 cellar: :any_skip_relocation, sierra:        "052fb1ae9a1546b13f865b25f4ff5879f4a7c77350d14720442fc6cd898d833d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e677c99a35fcedcf1022bbd06eac0f3868327d8bf8f16cf87c4d2cf867fb8f75"
  end

  # Makefile: upstream has been informed of the patch through email (multiple
  # times) but no plans yet to incorporate it https://github.com/snar/bgpq3/pull/2
  # there was discussion about this patch for 0.1.18 and 0.1.19 as well
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpq3", "AS-ANY"
  end
end

__END__
--- a/Makefile.in
+++ b/Makefile.in
@@ -32,8 +32,8 @@
 install: bgpq3
 	if test ! -d @bindir@ ; then mkdir -p @bindir@ ; fi
 	${INSTALL} -c -s -m 755 bgpq3 @bindir@
-	if test ! -d @prefix@/man/man8 ; then mkdir -p @prefix@/man/man8 ; fi
-	${INSTALL} -m 644 bgpq3.8 @prefix@/man/man8
+	if test ! -d @mandir@/man8 ; then mkdir -p @mandir@/man8 ; fi
+	${INSTALL} -m 644 bgpq3.8 @mandir@/man8

 depend:
 	makedepend -- $(CFLAGS) -- $(SRCS)
