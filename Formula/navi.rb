class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.10.0.tar.gz"
  sha256 "24d4a4d07d7b69179999f89e17eb27195d6cb614379682ab6c87ec73ae9b1473"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb2b9ef91d3492455453e10f36045f2ca0d836102ac06e25015582184f69d962" => :catalina
    sha256 "1b4f41387d80e95f9594d56fcf689c753273e13e17d867e133db3c7f21acc8bd" => :mojave
    sha256 "acba8b1cccbb73266adb6776387834c0f1595ea939bef6036651d50597b75609" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar", shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats best foo")
  end
end
