class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "41d6215e73f38eb1970d17f85c7eb683f556f803a608339a76da9030e160bbd6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0b6f7426e986d89f03e7dec402510023ac404c7e970c1539b746073bb83b0062"
    sha256 cellar: :any, big_sur:       "72e05f106e1b7414f63bce4ad4dc9df08e88df9be62f70a7275ba0f94352d3e8"
    sha256 cellar: :any, catalina:      "6801d4cb7e9d35570003869f1bf13f18bb47189df762cd227d15594113486934"
    sha256 cellar: :any, mojave:        "1b6e066e44ae89b62a3977a76b239ca6d5603158031b2cbd66e2246e08af2160"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", "-DBUILD_TESTING=OFF"
      system "make"
      system "make", "install"
    end
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
