class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.0.19.tar.gz"
  sha256 "3bdf0fbf5c396f39d1bc48b7360d598a50209c2d143d03467d4f42cb8bf91c5f"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "3096f15eb9b5206c949594e14ee1a803aa9623952c39d25841deb73145138f14" => :catalina
    sha256 "cbc70fb6ab1231699fa56f385fd417879bc3b15af2d39a971f67bdc7818cbb3e" => :mojave
    sha256 "d531dbdd18d8bfc7ccf636c6d276f2c7799bd2a7ebf7ab6f846abe8314b0f4a4" => :high_sierra
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
