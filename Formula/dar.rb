class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.7/dar-2.7.7.tar.gz"
  sha256 "c03e2f52efd65a2f047b60bbeda2460cb525165e1be32f110b60e0cece3f2cc9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dar"
    sha256 aarch64_linux: "4b999d2438a415ebbad7aa0d9d95b704cf9ee5bc6519d439b007b4f240eb04ed"
  end

  depends_on "libgcrypt"
  depends_on "lzo"

  uses_from_macos "zlib"

  on_intel do
    depends_on "upx" => :build
  end

  def install
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
