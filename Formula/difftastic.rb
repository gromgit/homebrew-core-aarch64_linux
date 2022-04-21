class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.27.0.tar.gz"
  sha256 "0574d0f3f3b1aab7116cc6a41ff6df8022e93daade0460cded6b16988d58e316"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a06d7857bad2776152935228c1dfd5c8ff6ad22b238390d8378b402dbb518a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "616cb3d3b8653bb2d5f31b1ebc473a1a6627689adde4a21706a9bbcb404a027e"
    sha256 cellar: :any_skip_relocation, monterey:       "de26f62e69a15f1612f312e805fcbb329c0d28b47bc4056c5b75095b4800e30a"
    sha256 cellar: :any_skip_relocation, big_sur:        "49414594512c9d427ea95c0f1b5df07196660685621ce51df10958cc516c467c"
    sha256 cellar: :any_skip_relocation, catalina:       "7ea0d3624e4ddfd8899232885035a5fe060a9ee2e7c8ed95d97e39087ed93ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "882e23e95736905c8b5ce7ebf7078c8157d900b8fb6fba0c2bbec1cf8f2f85fd"
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
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
