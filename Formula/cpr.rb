class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://whoshuu.github.io/cpr/"
  url "https://github.com/whoshuu/cpr.git",
      tag:      "1.5.2",
      revision: "41fbaca90160950f1397e0ffc6b58bd81063f131"
  license "MIT"
  head "https://github.com/whoshuu/cpr.git"

  bottle do
    cellar :any
    sha256 "3de3156e76c50a9c0177f2f6b7856f83d36a7687d070c467acc9424a986a43b1" => :catalina
    sha256 "477db140c07296b4fb3969b26d136afd1b7106625082cb57dfd8c274dd53da23" => :mojave
    sha256 "b0c9560ba7c1fe39dfdb316541526494ea685f7c34944882ed7823f769e1cda9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  # Fix system curl detection
  # See https://github.com/whoshuu/cpr/pull/428
  #
  # Remove in the next release
  patch do
    url "https://github.com/whoshuu/cpr/commit/451fd1a896c963367ebb3d77cfe4550b2d5636f3.patch?full_index=1"
    sha256 "74349209c5d28d9261871080341c735517b3e64e91ac6cc6884abb2767f14b33"
  end

  def install
    args = std_cmake_args
    args << "-DUSE_SYSTEM_CURL=ON"
    args << "-DBUILD_CPR_TESTS=OFF"

    system "cmake", ".", *args, "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"

    system "make", "clean"
    system "cmake", ".", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "make"
    lib.install "lib/libcpr.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lcpr",
                    "test.cpp", "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
