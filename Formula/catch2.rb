class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.13.1.tar.gz"
  sha256 "36bcc9e6190923961be11e589d747e606515de95f10779e29853cfeae560bd6c"
  license "BSL-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "878fb061374afd494cb7ba8dfacd7057429cca7e009275547b0a14fa85cb2571" => :catalina
    sha256 "c585f0e045230eaa0cbd5433fe499a2c8a93776f0087da60ad8e42bcc2c2e1af" => :mojave
    sha256 "03a59fe4e92229d80a64b5b3198f8da79b0a3b8086b4a19317b708fc1ea6332c" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define CATCH_CONFIG_MAIN
      #include <catch2/catch.hpp>
      TEST_CASE("Basic", "[catch2]") {
        int x = 1;
        SECTION("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SECTION("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
