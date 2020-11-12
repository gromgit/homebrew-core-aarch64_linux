class Sng < Formula
  desc "Enable lossless editing of PNGs via a textual representation"
  homepage "https://sng.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sng/sng-1.1.0.tar.gz"
  sha256 "119c55870c1d1bdc65f7de9dbc62929ccb0c301c2fb79f77df63f5d477f34619"
  license "Zlib"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "1cc13309bec2c482abe4817e9161273c441c81eac7d363bc60f03e3371e9dad1" => :catalina
    sha256 "d7fc7e7d8dd4bfac43c8b4bf4b2cb0032cfcd6167e51408636fc344972814653" => :mojave
    sha256 "c9a851897c8a9a286a5988e822175769ca3aa554c48bbcf859c01c635a0fb6b3" => :high_sierra
  end

  depends_on "libpng"
  depends_on "xorgrgb"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    system bin/"sng", "test.png"
    assert_include File.read("test.sng"), "width: 8; height: 8; bitdepth: 8;"
  end
end
