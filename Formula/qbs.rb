class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.24.0/qbs-src-1.24.0.tar.gz"
  sha256 "73c9ecb9de766ecbe245a7aac683bd7809f8a5e33a922686b9475fe8f45e467c"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a628930a930a6ae3071eec4b21042251527854bc7a354fb7d41cc4a8cbc7330a"
    sha256 cellar: :any,                 arm64_monterey: "6604f19798d5ac7ba45cbbca0d658c03dd76ad74379edafda35dea199ee02bed"
    sha256 cellar: :any,                 arm64_big_sur:  "3646df419c8ccdecd847bbf39c6acac7fe2fe2b38cc7f5f36d9add60f241feb7"
    sha256 cellar: :any,                 monterey:       "a9a91161f9711ba9854355380e8547ca29ba77e619567fc559f987104c19a08c"
    sha256 cellar: :any,                 big_sur:        "b1f0b1a4e33df0edf23f1f733319429cfaab01c77051edeeacaf5861488ac4e9"
    sha256 cellar: :any,                 catalina:       "887de87ffddffda4613f41a8375a437053eba0b43def2f806459c9c6a7fcd61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5521ca054e370bcb1853e2ee657d3fc9e7535d944a4617599f23e1b698ce145"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    qt5 = Formula["qt@5"].opt_prefix
    system "cmake", ".", "-DQt5_DIR=#{qt5}/lib/cmake/Qt5", "-DQBS_ENABLE_RPATH=NO",
                         *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "run", "-f", "test.qbs"
  end
end
