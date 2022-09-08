class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/1.9.2.tar.gz"
  sha256 "3bfbffb22c51f322780d10d3ca8f79424190d7ac4b5ad6ad896de08dbd06bf31"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "610f141ca99ea251e5326cb26685fc509d750ab46157823ec683b01f919366f4"
    sha256 cellar: :any,                 arm64_big_sur:  "c2dba3a539bb400f185806a36209da06f18dff628059a2853d3374fdbd138ca7"
    sha256 cellar: :any,                 monterey:       "8fa911c8d3a1914c774f899a5746770070baf1cd72c2bea6f76e547486d1f96e"
    sha256 cellar: :any,                 big_sur:        "09c5d92ac8e2e19c581765df2a7a7430fb9af9146c809b046252082ac954cbec"
    sha256 cellar: :any,                 catalina:       "9a43c51be89eeab77ecbca2b575016b124099aadcbf1a13d356a750f382a0d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba40b91ac436b5a0e9faf82c6358eeacd37b72f7147ca90ed587ce2a53f8b1f6"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCPR_FORCE_USE_SYSTEM_CURL=ON
      -DCPR_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ] + std_cmake_args

    system "cmake", "-S", ".", "-B", "build-shared", "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "build-static"
    lib.install "build-static/lib/libcpr.a"
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

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lcpr", "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
