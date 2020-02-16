class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.11.tar.gz"
  sha256 "f02efcd319f2793fbbb10abf68cfae5067a269adbc88e8812bfcbcfd66a20471"

  bottle do
    cellar :any_skip_relocation
    sha256 "83845ba0691dc886ffd850e68b5648d6c79e2c2d14ba7b584ed9b6890d783199" => :catalina
    sha256 "87bdcba0bd4c76204e842ac7acf171c0d1382903912a1f5e0e87825a9a567b06" => :mojave
    sha256 "3cd9a915be9b0b6935adf902d5dc36d93dce4daf131cbaa4c6621f79fc5f25e8" => :high_sierra
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
