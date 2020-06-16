class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.6.tar.gz"
  sha256 "9f0a69fec1216ac947991bb1e506cc97f130ae14cef1fc5bbce08daaea566b63"
  revision 1
  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "c04404ef94a5aa1182ff0550ad9d90525d7fcd9867e02b19731a2f687fe834d4" => :catalina
    sha256 "a777651644157942d777e594dc63f2ca5e8348d39453baf3513723026ab350e5" => :mojave
    sha256 "813bad7d3d7bb03e2da6f0db64efaeaa8070a2d4e44cfab52a12a3dd72f468e8" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "openssl@1.1"

  # Allow ios-webkit-debug-proxy to build with latest libplist/libimobiledevice:
  # https://github.com/google/ios-webkit-debug-proxy/pull/361
  patch do
    url "https://github.com/google/ios-webkit-debug-proxy/commit/7195575fc5981c9c92ad337029ee90d997551369.patch?full_index=1"
    sha256 "fbdf1e593cbfcf5a47007bef4a6f9b9b0209fb4349396b0f994c940d0e9c0dfa"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    base_port = free_port
    (testpath/"config.csv").write <<~EOS
      null:#{base_port},:#{base_port + 1}-#{base_port + 101}
    EOS

    fork do
      exec "#{bin}/ios_webkit_debug_proxy", "-c", testpath/"config.csv"
    end

    sleep(2)
    assert_match "iOS Devices:", shell_output("curl localhost:#{base_port}")
  end
end
