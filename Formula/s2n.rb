class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.17.tar.gz"
  sha256 "c6401d4292fdfd271b02ddb8748f5c7318ba2877a582e6a06bac1a3910e82679"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "526f1bf79ad6e5301ff308625369572f801797b6ccd1817ea5ab7904589ed69a"
    sha256 cellar: :any,                 arm64_big_sur:  "32f6ac12aedf388b727eec21a74746d2d96806db808159500d5e364cd25fd823"
    sha256 cellar: :any,                 monterey:       "5b914568b9c2909cf4ca7fa3e61d5e979119fe5c23a035d89002f6439989a87d"
    sha256 cellar: :any,                 big_sur:        "8d8749330dbaad25a2a34de545cbb13da6a4e392c05caa0ba45dd08a8708857f"
    sha256 cellar: :any,                 catalina:       "b8cefdf2d4f4e47c180d95d0adcecc1a437263d4322d45f2f411e70b99c79378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d51e77b75efe7e1a848b646bc425c6062920dbec46b9f533b647f7653abf167"
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
