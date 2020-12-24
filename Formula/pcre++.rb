class Pcrexx < Formula
  desc "C++ wrapper for the Perl Compatible Regular Expressions"
  homepage "https://www.daemon.de/PCRE"
  url "https://www.daemon.de/idisk/Apps/pcre++/pcre++-0.9.5.tar.gz"
  mirror "https://distfiles.openadk.org/pcre++-0.9.5.tar.gz"
  sha256 "77ee9fc1afe142e4ba2726416239ced66c3add4295ab1e5ed37ca8a9e7bb638a"
  license "LGPL-2.1-only"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d7f87e5350fa4a45e038d4c84fca1396fc46871b4431a36cb9008909976cd962" => :big_sur
    sha256 "878feefd05caca9c45b4d0cc0072918b46c095c5e82ca99cdc88255b9f4b7f14" => :arm64_big_sur
    sha256 "89e8509bb894e25b47fef5d110aa254467751847cfb356f4e22f7f97298c14b6" => :catalina
    sha256 "f4ab047c478328e02ff8030ecfe165d3094eea156508463ad9beb7e7bb68d87a" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  # Fix building with libc++. Patch sent to maintainer.
  patch :DATA

  def install
    pcre = Formula["pcre"]
    # Don't install "config.log" into doc/ directory.  "brew audit" will complain
    # about references to the compiler shims that exist there, and there doesn't
    # seem to be much reason to keep it around
    inreplace "doc/Makefile.am", "../config.log", ""
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-pcre-lib=#{pcre.opt_lib}",
                          "--with-pcre-include=#{pcre.opt_include}"
    system "make", "install"

    # Pcre++ ships Pcre.3, which causes a conflict with pcre.3 from pcre
    # in case-insensitive file system. Rename it to pcre++.3 to avoid
    # this problem.
    mv man3/"Pcre.3", man3/"pcre++.3"
  end

  def caveats
    <<~EOS
      The man page has been renamed to pcre++.3 to avoid conflicts with
      pcre in case-insensitive file system.  Please use "man pcre++"
      instead.
    EOS
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pcre++.h>
      #include <iostream>

      int main() {
        pcrepp::Pcre reg("[a-z]+ [0-9]+", "i");
        if (!reg.search("abc 512")) {
          std::cerr << "search failed" << std::endl;
          return 1;
        }
        if (reg.search("512 abc")) {
          std::cerr << "search should not have passed" << std::endl;
          return 2;
        }
        return 0;
      }
    EOS
    flags = ["-I#{include}", "-L#{lib}",
             "-I#{Formula["pcre"].opt_include}", "-L#{Formula["pcre"].opt_lib}",
             "-lpcre++", "-lpcre"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test_pcrepp", "test.cc", *flags
    system "./test_pcrepp"
  end
end

__END__
diff --git a/libpcre++/pcre++.h b/libpcre++/pcre++.h
index d80b387..21869fc 100644
--- a/libpcre++/pcre++.h
+++ b/libpcre++/pcre++.h
@@ -47,11 +47,11 @@
 #include <map>
 #include <stdexcept>
 #include <iostream>
+#include <clocale>
 
 
 extern "C" {
   #include <pcre.h>
-  #include <locale.h>
 }
 
 namespace pcrepp {
