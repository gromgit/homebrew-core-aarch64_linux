class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.18.0/qbs-src-1.18.0.tar.gz"
  sha256 "3d0211e021bea3e56c4d5a65c789d11543cc0b6e88f1bfe23c2f8ebf0f89f8d4"
  license :cannot_represent
  head "git://code.qt.io/qbs/qbs.git"

  bottle do
    cellar :any
    sha256 "7d794beab13a4b2c18474a85412e1cbeb5acfb5b4a40c35c45bfb06eab8f2d8e" => :big_sur
    sha256 "091c4c7af98fe1dc6805064d871fddd4da518fcf335f2640724fa702e5392b7a" => :arm64_big_sur
    sha256 "81095756000121b7f58830c2a3986e6e005b88802a732880aa4bd20d0ae65962" => :catalina
    sha256 "710ff184af0065767d3d2a512306656676d6bc0d123f40dc8e9d9cfabfb18f44" => :mojave
  end

  depends_on "qt"

  def install
    system "qmake", "qbs.pro", "QBS_INSTALL_PREFIX=#{prefix}", "CONFIG+=qbs_disable_rpath"
    system "make"
    system "make", "install", "INSTALL_ROOT=/"
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
