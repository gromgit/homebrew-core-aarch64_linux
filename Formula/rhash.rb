class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.3/rhash-1.4.3-src.tar.gz"
  sha256 "1e40fa66966306920f043866cbe8612f4b939b033ba5e2708c3f41be257c8a3e"
  license "0BSD"
  head "https://github.com/rhash/RHash.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rhash"
    sha256 aarch64_linux: "85af5ecb9e1d99780d8b5bc13216b609b1ad3eeb14fa2c3547d97e0818b219c5"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gettext"
    system "make"
    system "make", "install"
    lib.install "librhash/#{shared_library("librhash")}"
    system "make", "-C", "librhash", "install-lib-headers"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end
