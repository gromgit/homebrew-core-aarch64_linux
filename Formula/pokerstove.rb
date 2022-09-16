class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/v1.0.tar.gz"
  sha256 "68503e7fc5a5b2bac451c0591309eacecba738d787874d5421c81f59fde2bc74"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c78e5eb529a94f590e98a44a17be462f7c989216c720a11ce8de7119094a24e8"
    sha256 cellar: :any,                 arm64_big_sur:  "b23ac65c6f043988225c18293c845bfb4bd31484472b3709dc3e129cbafa27d4"
    sha256 cellar: :any,                 monterey:       "332eb0edc19fa1fceec6d91c732a10feac45a8f8dfb834bb82e377ce1da1d374"
    sha256 cellar: :any,                 big_sur:        "a017e6fe5e0dc3db899492c608fcfd8a80d3cbc326dc054085d60b285cf720fa"
    sha256 cellar: :any,                 catalina:       "b2ca35fe130a95db31220b8dc45df8e5182d9247745bd71cc05e874e7c5ee74d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5480687b29f1209c60df592fe55d412ac3e04631cf3539de6e3fe0f30ac959d"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  # Build against our googletest instead of the included one
  # Works around https://github.com/andrewprock/pokerstove/issues/74
  patch :DATA

  def install
    rm_rf "src/ext/googletest"

    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    unless OS.mac?
      inreplace "src/lib/pokerstove/util/CMakeLists.txt",
                "gtest_main", "gtest_main pthread"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install Dir["bin/*"]
    end
  end

  test do
    system bin/"peval_tests"
  end
end

__END__
--- pokerstove-1.0/CMakeLists.txt.ORIG	2021-02-14 19:26:14.000000000 +0000
+++ pokerstove-1.0/CMakeLists.txt	2021-02-14 19:26:29.000000000 +0000
@@ -14,8 +14,8 @@
 
 # Set up gtest. This must be set up before any subdirectories are
 # added which will use gtest.
-add_subdirectory(src/ext/googletest)
-find_library(gtest REQUIRED)
+#add_subdirectory(src/ext/googletest)
+find_package(GTest REQUIRED)
 include_directories(${GTEST_INCLUDE_DIRS})
 link_directories(${GTEST_LIBS_DIR})
 add_definitions("-fPIC")
