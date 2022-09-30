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
    sha256 cellar: :any,                 arm64_monterey: "b29336041337c7b8903a0fe64ec68c0efc84bcea9212554df2c246dc688f45a0"
    sha256 cellar: :any,                 arm64_big_sur:  "4a11c801bf1337ff94fc3b0583bc14c63cdd9e00cdf55c5cae6fe0c6644439f7"
    sha256 cellar: :any,                 monterey:       "7a1a4d28a1446e86fd5beee7b63cc700a4440baf35f3688b9e768b1082845a43"
    sha256 cellar: :any,                 big_sur:        "3ad77017bee5e6386998dc0d2a0127f5e7b12dc63a2fd0ba7cadeb7769a1f405"
    sha256 cellar: :any,                 catalina:       "649c844c98cf11a32c512c767d6b6560b8f84da67438a7cfec64d922306ef08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45d84c89ab6a66cba96bfc0c824dc292a15172d90e3834fa59b5830fb3de4546"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
