class Sng < Formula
  desc "Enable lossless editing of PNGs via a textual representation"
  homepage "https://sng.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sng/sng-1.1.0.tar.gz"
  sha256 "119c55870c1d1bdc65f7de9dbc62929ccb0c301c2fb79f77df63f5d477f34619"
  license "Zlib"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sng"
    sha256 aarch64_linux: "eb4bfc81ec049127289983dc5760b212754d4a253b6ab18aba5bd17a82f06def"
  end

  depends_on "libpng"
  depends_on "xorgrgb"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-rgbtxt=#{Formula["xorgrgb"].share}/X11/rgb.txt"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    system bin/"sng", "test.png"
    assert_includes File.read("test.sng"), "width: 8; height: 8; bitdepth: 8;"
  end
end
