class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.13.1.tar.gz"
  sha256 "5f130829bcfce96da8acfee943e2368625b26d83fb391d2f6409acd47923a342"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ced790989b7845581178f2f47ec83f5ee572f04e8c7ce7da9ce83510e7039128" => :big_sur
    sha256 "e7a7992c14c67dcf1e8002801abebe3e6bbe3b6b8c832959c09349fd167313dd" => :arm64_big_sur
    sha256 "e86d3fd04b70ffc30bbe1ad1424111c5af0490336269a96cd3b7fc3d6ab025cb" => :catalina
    sha256 "7232389d1f0f4d5f4fc5530e53aae2af5710fbd59cedf35ce2519b7e32958edd" => :mojave
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
