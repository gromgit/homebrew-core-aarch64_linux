class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.03.21.00/wangle-v2022.03.21.00.tar.gz"
  sha256 "3557884c78cd5b4ebf4ee48c89e056b30453f5e9a1f24e89e170b31e94fcdf90"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "82160bc453eca667ff9b64bdedfac68892d3ba0bd966ff6f24fcd56d87b396ed"
    sha256 cellar: :any,                 arm64_big_sur:  "d8d403947f01e2f28b86a35719ad19a984f6602c5c44fccb9099b7a36d1c45cb"
    sha256 cellar: :any,                 monterey:       "1019240a9cd189ab45f4ca5e1de3a6569fa0f298e0a4ea92a25d85ca50cf69b0"
    sha256 cellar: :any,                 big_sur:        "122420ef08a0c6a41448033fef240b3f46f00764a8ac0fff473df2ac0b046fbb"
    sha256 cellar: :any,                 catalina:       "213cf5f4aa1ad3b34f74001c7a3cbad4c6b5a04ed57258a37562ca814b461afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a1d77898a430a7df48ae7c8e93e47f5fbfeef95c26c8d727d64451de1919ed0"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    cd "wangle" do
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
      system "make", "clean"
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
      system "make"
      lib.install "lib/libwangle.a"

      pkgshare.install Dir["example/echo/*.cpp"]
    end
  end

  test do
    cxx_flags = %W[
      -std=c++14
      -I#{include}
      -I#{Formula["openssl@1.1"].opt_include}
      -L#{Formula["gflags"].opt_lib}
      -L#{Formula["glog"].opt_lib}
      -L#{Formula["folly"].opt_lib}
      -L#{Formula["fizz"].opt_lib}
      -L#{lib}
      -lgflags
      -lglog
      -lfolly
      -lfizz
      -lwangle
    ]
    if OS.linux?
      cxx_flags << "-L#{Formula["boost"].opt_lib}"
      cxx_flags << "-lboost_context-mt"
      cxx_flags << "-ldl"
      cxx_flags << "-lpthread"
    end

    system ENV.cxx, pkgshare/"EchoClient.cpp", *cxx_flags, "-o", "EchoClient"
    system ENV.cxx, pkgshare/"EchoServer.cpp", *cxx_flags, "-o", "EchoServer"

    port = free_port
    ohai "Starting EchoServer on port #{port}"
    fork { exec testpath/"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath/"EchoClient", "-port", port.to_s) do |r, w, pid|
      ohai "Sending data via EchoClient"
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
      Process.kill "TERM", pid
      begin
        ohai "Reading received data"
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end
