class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.04.12.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.04.12.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "bbc96e470bd47b23971a0ece7fc4d340e4ffd040dc483706504b3bc63d9622e0"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "66e443fae17d9d0d49d5ba7a1b479f21c3b5776a9a312395070ca8f290bf193b"
    sha256 cellar: :any,                 arm64_big_sur:  "7526fef8500e64c0227e1cdacc35d57a04815705bf70f978b3f719004241635c"
    sha256 cellar: :any,                 monterey:       "83f79e333fb6053fab2730419bc06d9e86d8d3fbb397dd58324b808f36509dd6"
    sha256 cellar: :any,                 big_sur:        "acb987693ae0d3c71ede9a853c76593e0a4dfedfd654ce69b4c21591615a7286"
    sha256 cellar: :any,                 catalina:       "38704c8eb113c5a19a75245c18039799261a68f16b3085d381d25172f49400fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9bf455d57a5d688086eb9afa2b2c155c5f8b0d213aa3a0c069a6371c386a5a6"
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
