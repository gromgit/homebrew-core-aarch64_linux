class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "http://www.catb.org/~esr/wumpus/wumpus-1.7.tar.gz"
  sha256 "892678a66d6d1fe2a7ede517df2694682b882797a546ac5c0568cc60b659f702"

  livecheck do
    url :homepage
    regex(/href=.*?wumpus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wumpus"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "818d944fa473ada821d5afd80c33c488e524297ed9133ccdc00b278f72b443f7"
  end

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_match("HUNT THE WUMPUS",
                 pipe_output(bin/"wumpus", "^C"))
  end
end
