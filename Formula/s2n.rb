class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.11.tar.gz"
  sha256 "b276d8b28cf9c2a6abf071a1055129af0ff4f606e5a5504546846c49105c1cf0"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0787d9e8eae51315a0878160c4ddbe37371893633abfd8f48220d0f79485d050"
    sha256 cellar: :any,                 arm64_big_sur:  "5091be418046e5ac6b61e8047a6b4392f48bb807c2fda28172ec9c10f04ed2c0"
    sha256 cellar: :any,                 monterey:       "97f4f29954d75f4c89c355ca0ba6c527d1959e25d74adda3c4483b4f1d72a415"
    sha256 cellar: :any,                 big_sur:        "e7c6608679ac0d8e2827d874374e969b88192ac1c521112e480efaa1ac4c1ead"
    sha256 cellar: :any,                 catalina:       "f3e38b94ccc1880be03fcf9e06ac51dfdd2c270dc99f5885a33e31fc5fd18059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2af86eddda09a9da12c67c27aed3ffd11433d4ee60eb8b8c6d9523c30e44fbc5"
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
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
