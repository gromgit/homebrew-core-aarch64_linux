class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.8.16.tar.gz"
  sha256 "8f0f014079f2769f3a9f4d01aeb79ed169398c8382a346699304cff32ba987da"

  bottle do
    cellar :any_skip_relocation
    sha256 "67f080e39c4698911fe4c9c90a514a627f1e94a7e2dae54c85bba728a344647c" => :catalina
    sha256 "9fe4865bba5c79e933eaf3e43353f39c7571ac6875e9abb80cea25cf5a40ac37" => :mojave
    sha256 "b6442f29ec0bad4589f91ba36e31103b1aff3829dc1ba8adda594d7d6debe6cc" => :high_sierra
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
