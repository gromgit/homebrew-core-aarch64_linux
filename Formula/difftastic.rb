class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.32.0.tar.gz"
  sha256 "58048d43ee61e16c0e2a2ab6efbb7453d6c8195557fb22cd8c62e19412713487"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3482a0e78b9842998584866f9e579989c72f9479727f78e533cd117ae38b0aac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "345871ab11b60003470e4bb61efcff2a6ba013fd8efbea84e81745be76c3a0f5"
    sha256 cellar: :any_skip_relocation, monterey:       "2a90ed5b424513757c1d4a814c961e9330d6cc34d48052b1f6610c37b181c087"
    sha256 cellar: :any_skip_relocation, big_sur:        "189bdcc1df975141a0f15f18a70ddc7e691f77995a2c8519d817f09933d8e4cb"
    sha256 cellar: :any_skip_relocation, catalina:       "c07c284a10375c45335b3be051c32dadbd28954ca4596d9773d609b47efa31ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc21b5607686995d2887604a57f4131c2cd23917df4aeb28e527fc54c2e5290"
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
