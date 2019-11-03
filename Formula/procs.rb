class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.8.11.tar.gz"
  sha256 "ff84d26e4acfcf2a904745436dfd939d9f66903f86bfdc1bcffed366a0461f80"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a44cec5a6df4464c2ffb4d53aab5f88ba728ba585b50fb742ac0bd8d92300a64" => :catalina
    sha256 "5f053e2ad6a8e314c96edc88c0e54ec61023ed1dc109934cd94e8e55bdbaf4cc" => :mojave
    sha256 "44f981cb8b658c10f110fec9b7c6f88293de2097bb3ff5386d660bf9bdbf8ac8" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
