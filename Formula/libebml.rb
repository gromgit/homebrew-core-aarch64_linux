class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  license "LGPL-2.1-or-later"
  head "https://github.com/Matroska-Org/libebml.git", branch: "master"

  # Remove stable block in next release with merged patch
  stable do
    url "https://dl.matroska.org/downloads/libebml/libebml-1.4.2.tar.xz"
    sha256 "41c7237ce05828fb220f62086018b080af4db4bb142f31bec0022c925889b9f2"

    # Fix compilation with GCC: error: 'numeric_limits' is not a member of 'std'
    # Ported from https://github.com/Matroska-Org/libebml/commit/f0bfd53647961e799a43d918c46cf3b6bff89806
    # Remove in the next release
    patch :DATA
  end

  livecheck do
    url "https://dl.matroska.org/downloads/libebml/"
    regex(/href=.*?libebml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "d3af7501c3d4eef59d70cbe6d0db0dabcf643f060b7167e90f5f84e598611831"
    sha256 cellar: :any,                 arm64_big_sur:  "f2b112005f974dbbc725949ba9c66cbca0dbb101934eaccfb15999d0694e2a0c"
    sha256 cellar: :any,                 monterey:       "5d981e2ec0b97d3d1fdeb73a905239ffa8d031c27f0b55b0a57436705afa9999"
    sha256 cellar: :any,                 big_sur:        "1cb134879583bcf749d5dbe0cb0fc0743b4323e224be904dc5865dd42e96e774"
    sha256 cellar: :any,                 catalina:       "6eed9db58a9132676dc1c2ff0877f48a6424afb465c9654887956cd845cee2c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e0784e6765ab397b2f121fb032e9f3a8dedf7e2745570126d377e88a384304b"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end

__END__
diff --git a/src/EbmlString.cpp b/src/EbmlString.cpp
index 27e55fdf6c98c52ab73c8f02d8c69e31505f93d7..4c05fcfea34988672f2d7084f34e874a6c99cfdc 100644
--- a/src/EbmlString.cpp
+++ b/src/EbmlString.cpp
@@ -34,6 +34,7 @@
   \author Steve Lhomme     <robux4 @ users.sf.net>
 */
 #include <cassert>
+#include <limits>
 
 #include "ebml/EbmlString.h"
 
diff --git a/src/EbmlUnicodeString.cpp b/src/EbmlUnicodeString.cpp
index 496a16acc293487e842bc5696b1fe2f93c204a12..99fc073776d228692475997fba9a5be3280ffc99 100644
--- a/src/EbmlUnicodeString.cpp
+++ b/src/EbmlUnicodeString.cpp
@@ -36,6 +36,7 @@
 */
 
 #include <cassert>
+#include <limits>
 
 #include "ebml/EbmlUnicodeString.h"
 
