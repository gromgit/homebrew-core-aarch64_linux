class Doctest < Formula
  desc "The fastest feature-rich C++11/14/17/20 single-header testing framework"
  homepage "https://github.com/onqtam/doctest"
  url "https://github.com/onqtam/doctest/archive/2.3.8.tar.gz"
  sha256 "d7232437eceb46ad5de03cacdee770c80f2e53e7b8efc1c8a8ed29539f64efa5"

  bottle do
    cellar :any_skip_relocation
    sha256 "783dddbe8389d03fa57cf7f6f2bc73ceb17686a90519418a1a7a22ac052e0bdb" => :catalina
    sha256 "783dddbe8389d03fa57cf7f6f2bc73ceb17686a90519418a1a7a22ac052e0bdb" => :mojave
    sha256 "783dddbe8389d03fa57cf7f6f2bc73ceb17686a90519418a1a7a22ac052e0bdb" => :high_sierra
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
