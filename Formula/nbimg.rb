class Nbimg < Formula
  desc "Smartphone boot splash screen converter for Android and winCE"
  homepage "https://github.com/poliva/nbimg"
  url "https://github.com/poliva/nbimg/archive/v1.2.1.tar.gz"
  sha256 "f72846656bb8371564c245ab34550063bd5ca357fe8a22a34b82b93b7e277680"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nbimg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "99735b1123129f44d168e5ef7562afd2135f0ee97991ecd9ce6aaea58e559e4e"
  end

  def install
    inreplace "Makefile", "all: nbimg win32", "all: nbimg"
    system "make", "prefix=#{prefix}",
                   "bindir=#{bin}",
                   "docdir=#{doc}",
                   "mandir=#{man}",
                   "install"
  end

  test do
    curl "https://gist.githubusercontent.com/staticfloat/8253400/raw/" \
         "41aa4aca5f1aa0a82c85c126967677f830fe98ee/tiny.bmp", "-O"
    system "#{bin}/nbimg", "-Ftiny.bmp"
  end
end
