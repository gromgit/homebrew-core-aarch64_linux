class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2020.08.10.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2020.08.10.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "6ea4084337bee7ea3647af8f0faa05dfc1e19a5bf68b5a83ad914edcb1772463"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "05849b3a28901533284012d35cbf15b5cb74b137ec9d3bfed9ee72965708c682" => :catalina
    sha256 "073f47c6da0d32f2dbb285db05bb7400c3ed379352c95b782fcf1a9a9b4ac2e8" => :mojave
    sha256 "e52bb044e226711cf4b56906f146c8a8f52aa72ecb1749220a92637ba9628fbf" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@1.1"].opt_lib/"libcrypto.dylib",
      Formula["openssl@1.1"].opt_lib/"libssl.dylib",
    ]

    system "./genMakefiles", "macosx"
    system "make", "PREFIX=#{prefix}",
           "LIBS_FOR_CONSOLE_APPLICATION=#{libs.join(" ")}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats
    <<~EOS
      Testing executables have been placed in:
        #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
