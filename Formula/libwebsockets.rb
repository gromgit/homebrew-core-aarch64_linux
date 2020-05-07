class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.0.7.tar.gz"
  sha256 "531e8f54fb9df64e790a3a62ace103dfbd67d2e3994745623422f89fbb7abcaf"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "02c6127dbd6c951153fb31ff2af6ab329f49a489b684c0a57ea89f75ea65584b" => :catalina
    sha256 "a0a6419c8d9c23fb56d2b13246daf81f8467f58e86cc392cefb1c6cb770d0db0" => :mojave
    sha256 "ff9b56d2c4909864016821fedc76bebdfa6bf1da24ea123b9b917d7db7d0144a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITH_PLUGINS=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON"
    system "make"
    system "make", "install"
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
