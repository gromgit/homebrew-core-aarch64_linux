class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-08-01.tar.gz"
  version "20200801"
  sha256 "6f4c8514249cd65b9e85d3e6f4c35595809a63ad71c5d93083e4d1dcdf9e0cd6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "442f27b4c00fd6dff32ecf2a21e5b70c572d056976439c1dc6b3d35790bcce91" => :catalina
    sha256 "702ebe295054c8e76ae5018c0109fad1e0154ba24a8764e2f87f484681140947" => :mojave
    sha256 "018ee2711b2c739074221a3248a812b23fbe97be5222b618fc254ce658242fdd" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    # Run this for pkg-config files
    system "make", "common-install", "prefix=#{prefix}"

    # Run this for the rest of the install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", "-DRE2_BUILD_TESTING=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lre2",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
