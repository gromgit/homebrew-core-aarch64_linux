class Doctest < Formula
  desc "Feature-rich C++11/14/17/20 single-header testing framework"
  homepage "https://github.com/onqtam/doctest"
  url "https://github.com/onqtam/doctest/archive/2.4.4.tar.gz"
  sha256 "3bcb62ad316bf4230873a336fcc6eb6292116568a6e19ab8cdd37a1610773d70"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b728e7c1f23ecdd4be4f4dbd0b8a70dec3a53736ba1e99a0ba24751a15a2f58" => :big_sur
    sha256 "77a40787ed1a545e41cf5b5b6ece7f88eafed3268b9b2cf09928a5dc9c0b81ef" => :catalina
    sha256 "bc4e4fb3237bc95328171dcce0ba3b38f963ebe450b39cfd5777238bc4c38db0" => :mojave
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
      #include <doctest/doctest.h>
      TEST_CASE("Basic") {
        int x = 1;
        SUBCASE("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SUBCASE("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
