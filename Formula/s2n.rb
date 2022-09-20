class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.23.tar.gz"
  sha256 "6cc65c621c31ecfcb472ea151f5bd1feba48ae837f8a5bd6fd54fb22d2a84638"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d0656c63f625502a3f5daf7b51238d73af7109cb1ba68828019abb1e64e0e799"
    sha256 cellar: :any,                 arm64_big_sur:  "6738f0cc57e7439096527a34213aa848e5e17d28c687b50ed2a7be4ec5221936"
    sha256 cellar: :any,                 monterey:       "62d3405ca7d6a67f2c7b25f96312fe41b800a89abb17f622430510ee6a10a780"
    sha256 cellar: :any,                 big_sur:        "bffd7011182181a056ea2d99cfa3922ad23ca661a583f88fba97a1df2b4d8d6e"
    sha256 cellar: :any,                 catalina:       "3fa497252ee20831af2a7f114afca58e9eb1067374be90437147b0b70a0b3e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff46c050fe41dbb645a63af7b0602cd6c3d2cb6fc7b0df3dd3885790c0f743a2"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
