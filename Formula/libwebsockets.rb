class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.3.1.tar.gz"
  sha256 "8fdb1454a1b34cd9a6351beaab237a485e6853806101de7e62bd2bc250bb50af"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "03158a8bffe0742fbd6a0fa3c01eecec1cd6727ee8109bfbfcbf4d1961ec7499"
    sha256 arm64_big_sur:  "9c977864a12c8da1156673306cb6bf2467eb834f2770f8081b33ab2245f8cd3c"
    sha256 monterey:       "d410b9cc69a4d485c28e65aeb3834449004cee9f1c586d7553b7902aca16fd1f"
    sha256 big_sur:        "ea9da6f7d019e78108372ac16c5ba0415ab3b75a1fda62ce491982ed93b6f0b3"
    sha256 catalina:       "384de640a58ac70329a9d3e54e6dbd6beaccec7fcecab003a44da80020b416e8"
    sha256 x86_64_linux:   "3e3a03480fcc61249e07c7b89602adb87d4a7f5e96bd7199d11df8e2cceea952"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITH_PLUGINS=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <openssl/ssl.h>
      #include <libwebsockets.h>

      int main()
      {
        struct lws_context_creation_info info;
        memset(&info, 0, sizeof(info));
        struct lws_context *context;
        context = lws_create_context(&info);
        lws_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["openssl@1.1"].opt_prefix}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
