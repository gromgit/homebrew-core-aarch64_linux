class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.12.tar.gz"
  sha256 "2f71e4e430bc1a09f7d70042d7b6c53005c5bfb0a59128c80c5b038e13040d56"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "542763159c5167cfa58d604f4d0ee724975d0fe591a0ca93d73d973dc569ca81"
    sha256 cellar: :any,                 arm64_big_sur:  "1cc231fabd2f624b4a5e5dd571a3cde85128a5b34faad188a7b7c591b9964398"
    sha256 cellar: :any,                 monterey:       "fbd54cd786dc00193429b9794b33d4f7bcd991085bea0a74e4e22d0e867a5c1d"
    sha256 cellar: :any,                 big_sur:        "ab5c32d818bbc502631aa51eecd8f7249acde9e1f8d0e5b7f359260f3b90649d"
    sha256 cellar: :any,                 catalina:       "836c5798089493d733fc7c25a6deddbf6a5ccf7d2a1ada79f9bfae8847e450c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a7918d91fd61e401c9cb8ff83aac0255905df0cfb9dc0bcfde8f9b873fd3631"
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
