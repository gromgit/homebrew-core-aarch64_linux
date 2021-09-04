class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.104.0.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.104.0.tar.gz"
  sha256 "a079d64cd55d6184510adfe0f341b2f278f7fb1bcc080d28d374298160f19cb2"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "de0e15a9827c466360b9cd0f2d3f193134834032998448d7981ac4a8f74b85b5"
    sha256 big_sur:       "0336a74d46b95394919ed3de66e3fe02a1e58993892f3e5221dea29ad56c301b"
    sha256 catalina:      "5b0e6cc76e434d7ebfb9301f4b6de21b647f7c0cb3a89d7ca7d6d92c37c34600"
    sha256 mojave:        "a7ebd59427dddd39419a5dceb5f6c85f55d6040d41878e4fca931e384f906fe2"
    sha256 x86_64_linux:  "f921185f5319873958091bd65bd535d33cb9230a3a9a94fd73041b42d7ed4074"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libtool"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "yara"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libiconv"
  end

  skip_clean "share/clamav"

  def install
    args = std_cmake_args + %w[
      -DENABLE_JSON_SHARED=ON
      -DENABLE_STATIC_LIB=ON
      -DENABLE_SHARED_LIB=ON
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
    ]

    on_linux do
      args << "-DENABLE_MILTER=OFF"
    end

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      To finish installation & run clamav you will need to edit
      the example conf files at #{etc}/clamav/
    EOS
  end

  test do
    system "#{bin}/clamav-config", "--version"
    (testpath/"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS
    system "#{bin}/freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system "#{bin}/clamscan", "--database=#{testpath}", testpath
  end
end
