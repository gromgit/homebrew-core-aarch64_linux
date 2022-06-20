class Png2ico < Formula
  desc "PNG to icon converter"
  homepage "https://www.winterdrache.de/freeware/png2ico/"
  url "https://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz"
  sha256 "d6bc2b8f9dacfb8010e5f5654aaba56476df18d88e344ea1a32523bb5843b68e"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?png2ico-src[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/png2ico"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "36f5c90e597f5dda353772c739fd0e0dd75e96f41f3a84b9f882fcf44faf60e4"
  end

  depends_on "libpng"

  # Fix build with recent clang
  patch :DATA

  def install
    inreplace "Makefile", "g++", "$(CXX)"
    system "make", "CPPFLAGS=#{ENV.cxxflags} #{ENV.cppflags} #{ENV.ldflags}"
    bin.install "png2ico"
    man1.install "doc/png2ico.1"
  end

  test do
    system "#{bin}/png2ico", "out.ico", test_fixtures("test.png")
    assert_predicate testpath/"out.ico", :exist?
  end
end

__END__
diff --git a/png2ico.cpp b/png2ico.cpp
index 8fb87e4..9dedb97 100644
--- a/png2ico.cpp
+++ b/png2ico.cpp
@@ -34,6 +34,8 @@ Notes about transparent and inverted pixels:
 #include <cstdio>
 #include <vector>
 #include <climits>
+#include <cstdlib>
+#include <cstring>

 #if __GNUC__ > 2
 #include <ext/hash_map>
