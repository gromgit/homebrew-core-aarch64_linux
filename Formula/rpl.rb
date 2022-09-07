class Rpl < Formula
  desc "Text replacement utility"
  homepage "http://www.laffeycomputer.com/rpl.html"
  url "https://web.archive.org/web/20170106105512/downloads.laffeycomputer.com/current_builds/rpl-1.4.1.tar.gz"
  sha256 "291055dc8763c855bab76142b5f7e9625392bcefa524b796bc4ddbcf941a1310"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rpl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3d2e1ef5b0a5d0ad2acc9595557090c5b292302083650ac1b7f54d90cf5fa3dd"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system "#{bin}/rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
