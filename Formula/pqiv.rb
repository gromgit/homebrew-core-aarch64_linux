class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.12.tar.gz"
  sha256 "1538128c88a70bbad2b83fbde327d83e4df9512a2fb560eaf5eaf1d8df99dbe5"
  license "GPL-3.0"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "5375b07cad6772b0450fb7ee5f959e448c454ad21c1bb7886eb297c879cfe614" => :big_sur
    sha256 "93dbe600eb2bf325ea774a9a60e238e60968166636d7c5005db798a1c26ed7d6" => :catalina
    sha256 "9b8bbaa8c9793c4e08321a120ffb34d0e6e11a5974ab2b0a34aadb0602fe0604" => :mojave
    sha256 "b8c49f6ea25654775bbaf5239afcf49ec0f896e3f6f5bfef7375382498082f29" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "webp"

  on_linux do
    depends_on "libtiff"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
