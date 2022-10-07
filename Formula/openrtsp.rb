class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.10.01.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.10.01.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "429de73061e3fc6901c4d2f0b7562ae3f6233060ca4b5e182fe555d065cbdd45"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9538e0be8658025b29b1d413478215b83d02af05d338bc53ceb9249e85d0ece8"
    sha256 cellar: :any,                 arm64_big_sur:  "5d79f6183a29cef73b228c51b9c7fd8eadcc49e83a38015f3bc66c02df657186"
    sha256 cellar: :any,                 monterey:       "56b0d6938774e857cddf7d1329dff61bd6ff07efe2cfebb3700e0ed138c65c5e"
    sha256 cellar: :any,                 big_sur:        "3d8a12b09eb0d09e0f44faf1b25e8f42ca56697b19315d68029ec93bf9d12a7b"
    sha256 cellar: :any,                 catalina:       "84a94b86d1f5fda4f303318da0bde3efe4adc11c21be4304fca140e76f404409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b546fbd05fb723867dda85a489197cfd22052c8eeed1e8177d2b1da94e36aa"
  end

  depends_on "openssl@1.1"

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-no-openssl" : "linux-no-openssl"
    system "./genMakefiles", os_flag
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
