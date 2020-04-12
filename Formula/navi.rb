class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.5.0.tar.gz"
  sha256 "36e8a144ec7be5684bb0731c310071b018991a5e327360791e4c849fae2422c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4029b1179826ace252506bda45edce37855fa596d31b547b4d8b230ecc53eb6" => :catalina
    sha256 "5b479d09471edafff9ebbccd2d02b871446b108480a8774b2d1d10ec89ab278b" => :mojave
    sha256 "3828a83ab40cf3605bf07aff4c66aecc5733e09ebe24c19ec33fcdaafa582309" => :high_sierra
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
