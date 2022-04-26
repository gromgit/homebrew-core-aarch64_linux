class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.04.26.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.04.26.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "24fd24d53da1ac8f8282173039e99c9952186c18404b1fc3b1d4c0e9f49414e7"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8557c1bfc1711de536db08757c19678cf09262b2673658d0bc8d29ea757c7f94"
    sha256 cellar: :any,                 arm64_big_sur:  "b43459b39233dcdbe74763d4603c4ad070c2036704ff71019fa9d0e4fca6e792"
    sha256 cellar: :any,                 monterey:       "47298570ac32ec7a04aa018f3257851a7d06a4e892826715f34e38f236c90e5e"
    sha256 cellar: :any,                 big_sur:        "f3f4661fd6e7a0645f2caa4c6dfcd16af177d88272e525923f787b149ffcd6e3"
    sha256 cellar: :any,                 catalina:       "0a0c5c734e91156b494aeee8229df5d06b2be9a6417b9422f1487c5f564a216d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "849d721bb5987869bc1979d479a8d7dfcb1fe910f7de018122747635916135dd"
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
