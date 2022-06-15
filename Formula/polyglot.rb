class Polyglot < Formula
  desc "Protocol adapter to run UCI engines under XBoard"
  homepage "https://www.chessprogramming.org/PolyGlot"
  url "http://hgm.nubati.net/releases/polyglot-2.0.4.tar.gz"
  sha256 "c11647d1e1cb4ad5aca3d80ef425b16b499aaa453458054c3aa6bec9cac65fc1"
  license "GPL-2.0"
  head "http://hgm.nubati.net/git/polyglot.git", branch: "learn"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/polyglot"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "97f08f208f8c5bc3aa27550e8dfa29e8de6dadb51240cc0e061905c30fec2476"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(/^PolyGlot \d\.\d\.[0-9a-z]+ by Fabien Letouzey/, shell_output("#{bin}/polyglot --help"))
  end
end
