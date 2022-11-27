class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.3.tar.gz"
  sha256 "1116419527edfe73717b71407fb6e06f46098fc8a8e6b0bb778c4c75dc9f64b9"
  license "MIT"
  revision 5
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "08876367ba2814425bc40a4bccb387594eaaa7a55355e1d5277878e19b5bc26b"
    sha256 arm64_big_sur:  "e71a28ca4d574a23fce354ceb56cf99eccf8e3ad98bc2a2aedea68bf8e03b69b"
    sha256 monterey:       "f6033cbb074d60e0465d19e401f55a88b6cdd8b9e0b1b61246fab604ca8ccdd8"
    sha256 big_sur:        "b974d4b90a3ebd86a37759e4e77ec0f75b8efc49fd6c03e47fdf0670f4ec9546"
    sha256 catalina:       "da907b437b4d66a8fdd2d81defa06dd7222adfdfa879444e42649ba6c030d6fd"
    sha256 x86_64_linux:   "5be7cb4675897d31db44f4c24d02d35384cbdd82d8c6e3de6538247a500d0cc6"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  uses_from_macos "vim" # needed for xxd

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                    "-Dlibwebsockets_DIR=#{Formula["libwebsockets"].opt_lib/"cmake/libwebsockets"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    fork do
      system "#{bin}/ttyd", "--port", port.to_s, "bash"
    end
    sleep 5

    system "curl", "-sI", "http://localhost:#{port}"
  end
end
