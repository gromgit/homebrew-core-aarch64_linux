class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2020.05.15.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2020.05.15.tar.gz"
  sha256 "54bfa9bf10e979d742b687339595968c9b443afbb5f264682daa024c74756cb9"

  bottle do
    cellar :any
    sha256 "aae481712ae90a4d15ead77077055f5e962ef254bf4aafd96ef0e980c6567b95" => :catalina
    sha256 "ff0b776048bacd096f3bb2213415fe3b28a227faae9c048dabf06fd092972cdd" => :mojave
    sha256 "0f36e0d4d5fc6e377f62a113e4898690410742a90c297af5abfae3e811ba5964" => :high_sierra
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
