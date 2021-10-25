class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.1.2.tar.gz"
  sha256 "91b5940ff345482cfd582a4c6d04950a9788f70ac3e383af41ac1eeee0441d1e"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "353daa077f530a3e0036fc268dc2245bdc93b4ba0e4395f4402ea3c97cd6b188"
    sha256 cellar: :any, big_sur:       "a02e04a29c405a4071cee02974d32fdae96d419bb1de222f2755169a01cbd4f9"
    sha256 cellar: :any, catalina:      "76a348442bea725c1a98cac4586ed67fdbfdbe99ed17987a3de4703e66c50c1f"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    system "./test"
  end
end
