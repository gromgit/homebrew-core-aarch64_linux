class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.15.0.tar.gz"
  sha256 "60037f702975f141ab10de2287b19032907a773624319ccc1700cbabfb5549bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "142e4f63fddb60751221dc616e65e648c70f3f6ba5c00a7494c25d2f747d89f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "4eadb3ffacf68d6b6d5a975a3b5aa7bfa6c387be4afdf1d4b35e0807c988d634"
    sha256 cellar: :any_skip_relocation, catalina:      "0cf7416070e50df2d77c2fe884d9aef7efddb45712ca25297ef1c309add000b4"
    sha256 cellar: :any_skip_relocation, mojave:        "f8d57cd8fa62b6d4028bfe55f2a4af5e072bca0e31da6e3cf529d0c6d06bec58"
  end

  depends_on "rust" => :build
  depends_on "fzf"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar",
        shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats --query foo --best-match")
  end
end
