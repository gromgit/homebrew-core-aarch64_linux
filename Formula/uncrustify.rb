class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.73.0.tar.gz"
  sha256 "2df0326ba8c413d675b796e051d89a318b7c9cccebc993d66466e2e7fd970672"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2dcaa936d7a4059325a7b8ed903de60ff871123c7d1840292737739b64648b46"
    sha256 cellar: :any_skip_relocation, big_sur:       "aeaebd9ff33c221237ba005017f7d62012e82d7a0c9a10102bfa57ca71fb7358"
    sha256 cellar: :any_skip_relocation, catalina:      "4f50d6e3159241c0f561515465d86b771910a2071407b7b5ed7a4f9d70599e3c"
    sha256 cellar: :any_skip_relocation, mojave:        "58f40e9a613182248edb886953f23d3750580388effc02397ce04760d4f227a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b67ac94cb04cd58c14ed139a4718c440b4377e7fcf4b278a0313c7e1dcaa4d5"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # patches from https://github.com/uncrustify/uncrustify/pull/3178
  # and https://github.com/uncrustify/uncrustify/pull/3179 that fix build failures
  # can be removed for 0.74.0
  patch :DATA

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~EOS
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<~EOS
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{doc}/htdocs/default.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end

__END__
diff --git a/src/output.cpp b/src/output.cpp
index fd60ebab61..eb22edce04 100644
--- a/src/output.cpp
+++ b/src/output.cpp
@@ -17,13 +17,10 @@
 #include "unc_ctype.h"
 #include "unicode.h"
 
+#include <map>
 #include <regex>
 #include <set>
 
-#ifdef WIN32
-#include <map>                    // to get std::map
-#endif // WIN32
-
 
 constexpr static auto LCURRENT = LOUTPUT;
 
diff --git a/src/tokenize.cpp b/src/tokenize.cpp
index f0a4e2d95f..f412b6f138 100644
--- a/src/tokenize.cpp
+++ b/src/tokenize.cpp
@@ -16,10 +16,7 @@
 #include "unc_ctype.h"
 
 #include <regex>
-
-#ifdef WIN32
-#include <stack>            // to get std::stack
-#endif // WIN32
+#include <stack>
 
 
 #define LE_COUNT(x)    cpd.le_counts[static_cast<size_t>(LE_ ## x)]

diff --git a/src/backup.cpp b/src/backup.cpp
index c2a9ae51b5..18d4f854f8 100644
--- a/src/backup.cpp
+++ b/src/backup.cpp
@@ -29,9 +29,7 @@
 #include "md5.h"
 #include "unc_ctype.h"
 
-#ifdef __APPLE__
-#include <cerrno>                // is needed under OSX
-#endif
+#include <cerrno>
 
 using namespace std;
 
diff --git a/src/keywords.cpp b/src/keywords.cpp
index 5e4be69103..56a8a69363 100644
--- a/src/keywords.cpp
+++ b/src/keywords.cpp
@@ -13,6 +13,7 @@
 #include "args.h"
 #include "prototypes.h"
 
+#include <cerrno>
 #include <map>
 
 
diff --git a/src/uncrustify.cpp b/src/uncrustify.cpp
index bc01f53e23..7ad986cfa7 100644
--- a/src/uncrustify.cpp
+++ b/src/uncrustify.cpp
@@ -43,6 +43,7 @@
 #include "universalindentgui.h"
 #include "width.h"
 
+#include <cerrno>
 #include <fcntl.h>
 #include <map>
 #ifdef HAVE_UNISTD_H
