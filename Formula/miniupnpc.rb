class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "http://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.2.3.tar.gz"
  sha256 "dce41b4a4f08521c53a0ab163ad2007d18b5e1aa173ea5803bd47a1be3159c24"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/miniupnpc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1787492aa953003f3adaa66097087091565d99b5ce6c2ee2a27f39869a4550c0"
  end

  # Fix missing references to $(BUILD) in the install rules
  # equivalent to https://github.com/miniupnp/miniupnp/commit/ed1dc4bb5cdc4a53963f3eb01089289e30acc5a3
  # but modified to start with the miniupnpc folder as root
  patch :DATA

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end

__END__
diff --git a/Makefile b/Makefile
index 4563b283..11a17f95 100644
--- a/Makefile
+++ b/Makefile
@@ -162,7 +162,7 @@ PKGCONFIGDIR = $(INSTALLDIRLIB)/pkgconfig
 
 FILESTOINSTALL = $(LIBRARY) $(EXECUTABLES)
 ifeq (, $(findstring amiga, $(OS)))
-FILESTOINSTALL += $(SHAREDLIBRARY) miniupnpc.pc
+FILESTOINSTALL += $(SHAREDLIBRARY) $(BUILD)/miniupnpc.pc
 endif
 
 
@@ -251,15 +251,15 @@ install:	updateversion $(FILESTOINSTALL)
 	$(INSTALL) -m 644 $(LIBRARY) $(DESTDIR)$(INSTALLDIRLIB)
 ifeq (, $(findstring amiga, $(OS)))
 	$(INSTALL) -m 644 $(SHAREDLIBRARY) $(DESTDIR)$(INSTALLDIRLIB)/$(SONAME)
-	ln -fs $(SONAME) $(DESTDIR)$(INSTALLDIRLIB)/$(SHAREDLIBRARY)
+	ln -fs $(SONAME) $(DESTDIR)$(INSTALLDIRLIB)/$(notdir $(SHAREDLIBRARY))
 	$(INSTALL) -d $(DESTDIR)$(PKGCONFIGDIR)
-	$(INSTALL) -m 644 miniupnpc.pc $(DESTDIR)$(PKGCONFIGDIR)
+	$(INSTALL) -m 644 $(BUILD)/miniupnpc.pc $(DESTDIR)$(PKGCONFIGDIR)
 endif
 	$(INSTALL) -d $(DESTDIR)$(INSTALLDIRBIN)
 ifneq (, $(findstring amiga, $(OS)))
-	$(INSTALL) -m 755 upnpc-static $(DESTDIR)$(INSTALLDIRBIN)/upnpc
+	$(INSTALL) -m 755 $(BUILD)/upnpc-static $(DESTDIR)$(INSTALLDIRBIN)/upnpc
 else
-	$(INSTALL) -m 755 upnpc-shared $(DESTDIR)$(INSTALLDIRBIN)/upnpc
+	$(INSTALL) -m 755 $(BUILD)/upnpc-shared $(DESTDIR)$(INSTALLDIRBIN)/upnpc
 endif
 	$(INSTALL) -m 755 external-ip.sh $(DESTDIR)$(INSTALLDIRBIN)/external-ip
 ifeq (, $(findstring amiga, $(OS)))
