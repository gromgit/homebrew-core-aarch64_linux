class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.5.1.tar.gz"
  sha256 "0c6f2b32c27e81cfb43a3f781dbdc7404d1afaf7f1e9a3cb178c2054493d54a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1582261e962b8935dd9cb531a20f1b07913ee5216e38d42f275edeb75e0a1c1" => :catalina
    sha256 "b72d0751b8c3086a751e9fcb8a9eb2ddc352d84dfc6b5244d20d3c0acf9c455d" => :mojave
    sha256 "6c3afa49b15f8a8e15bbaba15ebab0a683cd270c97121d7639ddf86fa43d6d3a" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar", shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats best foo")
  end
end
