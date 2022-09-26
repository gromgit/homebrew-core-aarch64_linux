class Fnlfmt < Formula
  desc "Formatter for Fennel code"
  homepage "https://git.sr.ht/~technomancy/fnlfmt"
  url "https://git.sr.ht/~technomancy/fnlfmt/archive/0.2.3.tar.gz"
  sha256 "0a7d7aaf4d88a81b6f13ed02fa88e74ed6c634ba50254de09eeb5a7777ae90d6"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fnlfmt"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0698e6f840f6682f69eeb95da63d3ba414acdf3604efcbaf9a3011b4a8259280"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fnlfmt"
  end

  test do
    (testpath/"testfile.fnl").write("(fn [abc def] nil)")
    expected = "(fn [abc def]\n  nil)\n\n"
    assert_equal expected, shell_output("#{bin}/fnlfmt #{testpath}/testfile.fnl")
  end
end
