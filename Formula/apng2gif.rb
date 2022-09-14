class Apng2gif < Formula
  desc "Convert APNG animations into animated GIF format"
  homepage "https://apng2gif.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/apng2gif/1.8/apng2gif-1.8-src.zip"
  sha256 "9a07e386017dc696573cd7bc7b46b2575c06da0bc68c3c4f1c24a4b39cdedd4d"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/apng2gif"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e6107ca05d461d9d2e51b363b61fcdf1e53c6b964ff0946dea700746a2d6d8a6"
  end


  depends_on "libpng"

  def install
    system "make"
    bin.install "apng2gif"
  end

  test do
    cp test_fixtures("test.png"), testpath/"test.png"
    system bin/"apng2gif", testpath/"test.png"
    assert_predicate testpath/"test.gif", :exist?, "Failed to create test.gif"
  end
end
