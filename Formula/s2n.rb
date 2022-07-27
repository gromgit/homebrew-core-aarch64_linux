class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.18.tar.gz"
  sha256 "21f4e5c95cf793bb13b0dc51cb11d5936af37ba44ee3cf45a1c6f133b546b5d8"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e3a6ec5930bbbbd62db58b5846a9a436d5c12c5a107313ee4049407c660022db"
    sha256 cellar: :any,                 arm64_big_sur:  "2574b90049a485ffaf5976c8e3ad2be27510f102e1d1d5f821c072ebf7e06c6a"
    sha256 cellar: :any,                 monterey:       "beff83b7a961ac4dcfca12289f04801eb6684025c90a7cb183fa91e777494e1c"
    sha256 cellar: :any,                 big_sur:        "c8071e467d53888827ba9430177cf5a99076dfe03c368fe4c82a09bf7f3428e5"
    sha256 cellar: :any,                 catalina:       "90d37bae6ce993056d008b56b045b7c6e65cc82ea7e09bb784884fba40d7d6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "398b8360d7b46ef40c86d332a64411c0637ba3355feca73762bdc1a1f0edea08"
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
