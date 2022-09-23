class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  # pull from git tag to get submodules
  url "https://github.com/Microsoft/cpprestsdk.git",
      tag:      "2.10.18",
      revision: "122d09549201da5383321d870bed45ecb9e168c5"
  license "MIT"
  head "https://github.com/Microsoft/cpprestsdk.git", branch: "development"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cpprestsdk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c95cecfa337a84ca73cfd3051080c01508dee105ce720e145f06aa8e9b7c150f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", "-DBUILD_SAMPLES=OFF", "-DBUILD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"]}.opt_prefix",
                    "Release", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <cpprest/http_client.h>
      int main() {
        web::http::client::http_client client(U("https://example.com/"));
        std::cout << client.request(web::http::methods::GET).get().extract_string().get() << std::endl;
      }
    EOS
    system ENV.cxx, "test.cc", "-std=c++11",
                    "-I#{Formula["boost"].include}", "-I#{Formula["openssl@1.1"].include}", "-I#{include}",
                    "-L#{Formula["boost"].lib}", "-L#{Formula["openssl@1.1"].lib}", "-L#{lib}",
                    "-lssl", "-lcrypto", "-lboost_random-mt", "-lboost_chrono-mt", "-lboost_thread-mt",
                    "-lboost_system-mt", "-lboost_filesystem-mt", "-lcpprest",
                    "-o", "test_cpprest"
    assert_match "<title>Example Domain</title>", shell_output("./test_cpprest")
  end
end
