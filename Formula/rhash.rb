class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.2/rhash-1.4.2-src.tar.gz"
  sha256 "600d00f5f91ef04194d50903d3c79412099328c42f28ff43a0bdb777b00bec62"
  license "0BSD"
  head "https://github.com/rhash/RHash.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rhash"
    sha256 aarch64_linux: "fa812c253eed893385c524de30d2042cff631930fb215c9d76579c9e52b49d2e"
  end

  # configure: fix clang detection on macOS
  # Patch accepted and merged upstream, remove on next release
  patch do
    url "https://github.com/rhash/RHash/commit/4dc506066cf1727b021e6352535a8bb315c3f8dc.patch?full_index=1"
    sha256 "3fbfe4603d2ec5228fd198fc87ff3ee281e1f68d252c1afceaa15cba76e9b6b4"
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
