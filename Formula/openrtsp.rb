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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6aac9bb9d3d0062af0841bf474e68b33d39643c4e63383ee9f6b1d446eb268dc"
    sha256 cellar: :any,                 arm64_monterey: "daccddb45b414c2e3d82cd5358a48432cf0aacdf245887fd84f0b7838088d6ce"
    sha256 cellar: :any,                 arm64_big_sur:  "a3395fe4703cfe776bf0e088a88a473d43f70bfc6dc45734ad254b32264dad85"
    sha256 cellar: :any,                 monterey:       "c8733ed1d4afc4039448b003ded884f2483bd799ef67981fe174527f36f99a21"
    sha256 cellar: :any,                 big_sur:        "823f0acb202ab171a1c084616de4951113463d282d90182290667488e1be0e2d"
    sha256 cellar: :any,                 catalina:       "7b175ddda9e973ed2a51f3262cd9158f71babdc9bb933994f604d9c036c66d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0503bb86661dc1c229390b18fbc1ca133019e5b204603e6cc64c99c58a5bc68"
  end

  depends_on "openssl@3"

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
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
