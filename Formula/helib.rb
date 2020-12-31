class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v1.3.1.tar.gz"
  sha256 "8ef47092f6b15fbb484a21f9184e7d936c360198515b6efb9a55d3dfbc2ea4be"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "25cbd96cd9585d9e5be0fb45074e86c142abe8466c5d1f6dec5f128dfe3c71b5" => :big_sur
    sha256 "ec945f50a4fb75b7a4192d0aaa42c962892d09f2d2483dd69585ef6f92ed2c38" => :arm64_big_sur
    sha256 "3ed8276b4065f2ca26b2289f350ddbeebb458545df7cee0de12acf6e7d1eb70d" => :catalina
    sha256 "a634c79d901656f8ba5d340241c4ff00e8811ae184542c1c609fc26186b2dc9e" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "bats-core" => :test
  depends_on "ntl"

  def install
    mkdir "build" do
      system "cmake", "-DBUILD_SHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/BGV_country_db_lookup/BGV_country_db_lookup.cpp", testpath/"test.cpp"
    mkdir "build"
    system ENV.cxx, "-std=c++17", "-L#{lib}", "-L#{Formula["ntl"].opt_lib}",
                    "-lhelib", "-lntl", "test.cpp", "-o", "build/BGV_country_db_lookup"

    cp_r pkgshare/"examples/tests", testpath
    system "bats", "."
  end
end
