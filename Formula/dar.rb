class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.6.11/dar-2.6.11.tar.gz"
  sha256 "5763e660b31ca494f67543026abfba778022915c8feef95672c9f5f5aa5cd4eb"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "28e9c61e67567ec88c5ce1056ac4e00e873f57f470220f392ffce2449fa5bf49" => :catalina
    sha256 "43b0ba4f88cad4cd9d695663c0b2931f752e1b9c40778698388367971a6dd533" => :mojave
    sha256 "78a2778edc7db9fa67e9c72fabd8725a94d2abae2473bb73b25c876dcb9d7e51" => :high_sierra
  end

  depends_on "upx" => :build
  depends_on "libgcrypt"
  depends_on "lzo"
  depends_on macos: :el_capitan # needs thread-local storage

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-dependency-tracking",
                          "--disable-libxz-linking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
