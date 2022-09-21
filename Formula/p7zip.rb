class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://github.com/jinfeihan57/p7zip"
  url "https://github.com/jinfeihan57/p7zip/archive/v17.04.tar.gz"
  sha256 "ea029a2e21d2d6ad0a156f6679bd66836204aa78148a4c5e498fe682e77127ef"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/p7zip"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0530355fa3c4a3f7f886c89abf051da367786891dcfe7553b2ee182f8dbf26b5"
  end

  # Remove non-free RAR sources
  patch :DATA

  def install
    if OS.mac?
      mv "makefile.macosx_llvm_64bits", "makefile.machine"
    else
      mv "makefile.linux_any_cpu", "makefile.machine"
    end
    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7z", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7z", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", File.read(testpath/"out/foo.txt")
  end
end

__END__
diff -u -r a/makefile b/makefile
--- a/makefile	2021-02-21 14:27:14.000000000 +0800
+++ b/makefile	2021-02-21 14:27:31.000000000 +0800
@@ -31,7 +31,6 @@
 	$(MAKE) -C CPP/7zip/UI/Client7z           depend
 	$(MAKE) -C CPP/7zip/UI/Console            depend
 	$(MAKE) -C CPP/7zip/Bundles/Format7zFree  depend
-	$(MAKE) -C CPP/7zip/Compress/Rar          depend
 	$(MAKE) -C CPP/7zip/UI/GUI                depend
 	$(MAKE) -C CPP/7zip/UI/FileManager        depend

@@ -42,7 +41,6 @@
 common7z:common
 	$(MKDIR) bin/Codecs
 	$(MAKE) -C CPP/7zip/Bundles/Format7zFree all
-	$(MAKE) -C CPP/7zip/Compress/Rar         all

 lzham:common
 	$(MKDIR) bin/Codecs
@@ -67,7 +65,6 @@
 	$(MAKE) -C CPP/7zip/UI/FileManager       clean
 	$(MAKE) -C CPP/7zip/UI/GUI               clean
 	$(MAKE) -C CPP/7zip/Bundles/Format7zFree clean
-	$(MAKE) -C CPP/7zip/Compress/Rar         clean
 	$(MAKE) -C CPP/7zip/Compress/Lzham       clean
 	$(MAKE) -C CPP/7zip/Bundles/LzmaCon      clean2
 	$(MAKE) -C CPP/7zip/Bundles/AloneGCOV    clean
