class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.21.tar.gz"
  sha256 "415120a7baefaf56e122af93d4c0f51ee96afe00b79b7f4990cb0dbc4d8a6b8b"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b5efe8efe7a5acc9a19a33b8bebf4c83a0f3c35430cb7ec82716c7eeeded88fb"
    sha256 cellar: :any,                 arm64_big_sur:  "50320da9e06bf16fed6ccc9f06958b9fb3b9167105158d47bbdd142c3681e870"
    sha256 cellar: :any,                 monterey:       "6cb8acf250d085d64802b89bf7bb05ab4694ad0feece99c1bad0fce40bc9a76b"
    sha256 cellar: :any,                 big_sur:        "bf1802cbca15c10408f56e8513eba543d2fbaaa6493318cddc63b8e948e4f4e1"
    sha256 cellar: :any,                 catalina:       "9f1b3f6a0036668100fe7e06c10063c71f545a75bf3a490252597d6c2dc5bfe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29b394289603e9913ad08ec4348972ee1b8dda3cf129dccf2e289d8b5d72e744"
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
