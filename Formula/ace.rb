class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_12/ACE-6.5.12.tar.bz2"
  sha256 "ccd94fa45df1e8bb1c901d02c0a64c1626497e5eeda2f057fcf0a1578dae2148"
  license "DOC"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/ACE(?:%2B[A-Z]+)*?[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "35421f2b6d685d304bf091673f470509e4c7e91c682d49001807b8449d8b6b0c" => :big_sur
    sha256 "c8df669ae59fcf41cbfea88a8316965332f46e77886e21e1ea3848352c6b0e48" => :catalina
    sha256 "40e6474093ba8816d8693a6979e121138edd3b4f3619da51ca1ab8c0e9a3f9ae" => :mojave
  end

  # Fix issues with detection of newer OS/X versions; makefiles 6.5.12 are OK with
  # new versions in the form "10.X" but not "11.X":
  patch :DATA

  def install
    ln_sf "config-macosx.h", "ace/config.h"
    ln_sf "platform_macosx.GNU", "include/makeinclude/platform_macros.GNU"
    copy "include/makeinclude/platform_macosx_mojave.GNU", "include/makeinclude/platform_macosx_catalina.GNU"
    copy "include/makeinclude/platform_macosx_catalina.GNU", "include/makeinclude/platform_macosx_bigsur.GNU"

    # Set up the environment the way ACE expects during build.
    ENV["ACE_ROOT"] = buildpath
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/lib"

    # Done! We go ahead and build.
    system "make", "-C", "ace", "-f", "GNUmakefile.ACE",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "examples"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end

__END__
--- ACE_wrappers/include/makeinclude/platform_macosx.GNU.ORIG	2020-12-21 06:28:12.000000000 +0000
+++ ACE_wrappers/include/makeinclude/platform_macosx.GNU	2020-12-21 06:36:17.000000000 +0000
@@ -20,19 +20,25 @@
 MACOS_CODENAME_VER_10_12  := sierra
 MACOS_CODENAME_VER_10_13  := highsierra
 MACOS_CODENAME_VER_10_14  := mojave
-MACOS_CODENAME_VER_latest := mojave
-
-MACOS_CODENAME = $(MACOS_CODENAME_VER_$(MACOS_MAJOR_VERSION)_$(MACOS_MINOR_VERSION))
+MACOS_CODENAME_VER_10_15  := catalina
+MACOS_CODENAME_VER_11     := bigsur
+MACOS_CODENAME_VER_latest := bigsur
 
 ifeq ($(MACOS_MAJOR_VERSION),10)
-  ifeq ($(shell test $(MACOS_MINOR_VERSION) -gt 14; echo $$?),0)
-    ## if the detected version is greater than the latest know version,
-    ## just use the latest known version
-    MACOS_CODENAME = $(MACOS_CODENAME_VER_latest)
+  MACOS_CODENAME = $(MACOS_CODENAME_VER_$(MACOS_MAJOR_VERSION)_$(MACOS_MINOR_VERSION))
+  ifeq ($(shell test $(MACOS_MINOR_VERSION) -gt 15; echo $$?),0)
+    ## Unsupported minor version
+    $(error Unsupported MacOS version $(MACOS_RELEASE_VERSION))
   else ifeq ($(shell test $(MACOS_MINOR_VERSION) -lt 2; echo $$?),0)
     ## Unsupported minor version
     $(error Unsupported MacOS version $(MACOS_RELEASE_VERSION))
   endif
+else ifeq ($(shell test $(MACOS_MAJOR_VERSION) -gt 11; echo $$?),0)
+  ## if the detected version is greater than the latest know version,
+  ## just use the latest known version
+  MACOS_CODENAME = $(MACOS_CODENAME_VER_latest)
+else ifeq ($(shell test $(MACOS_MAJOR_VERSION) -gt 10; echo $$?),0)
+  MACOS_CODENAME = $(MACOS_CODENAME_VER_$(MACOS_MAJOR_VERSION))
 else
   ## Unsupported major version
   $(error Unsupported MacOS version $(MACOS_RELEASE_VERSION))
