class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.31.0.tar.gz"
  sha256 "0f6370aef09eed8cfd03add1b347dc2c3b84009493af7cbcf3ee5c12935cdac7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42d4cf3d361b58a157dafa7d6ca663b4fc0cee998ad09983276e481e4ad3914b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e463655c55434508f1d1e1561f734c748434b7cc77aed0199a426e70e13d7bba"
    sha256 cellar: :any_skip_relocation, monterey:       "f7c15cbb069d94040a288cfcaa66c4ba1cb459a4e20875317bd80ab7ab90d5a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "93c2455911f4527012c6a050e47d972ad730fe914840582603c5023074356fed"
    sha256 cellar: :any_skip_relocation, catalina:       "a5a7ce9a764d01f6ac9965e412c1178adba17d1c5d673fe8924f0cc6095b74f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f6ae7e2a3e8a7082c0f5598982b165b16f8d8f735138d690e46ce4e717afe0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      a.py --- Python
      1 print(42) 1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
