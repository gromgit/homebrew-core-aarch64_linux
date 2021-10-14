class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://github.com/oz/tz/archive/refs/tags/v0.6.tar.gz"
  sha256 "64d9b894a80c4478361774a8151574426f50d9185ca7b289b89ca04e0f47ecfc"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "095758a0ce88d49b3df127854862d39359ab5449543dc9525609000eb673133f"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2bfa56237ba4a0165ecdf1911cb1afcf68d82357c9bf71afd7c68ae9721c1e6"
    sha256 cellar: :any_skip_relocation, catalina:      "a2bfa56237ba4a0165ecdf1911cb1afcf68d82357c9bf71afd7c68ae9721c1e6"
    sha256 cellar: :any_skip_relocation, mojave:        "a2bfa56237ba4a0165ecdf1911cb1afcf68d82357c9bf71afd7c68ae9721c1e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    # Bubbletea-based apps are hard to test even under PTY.spawn (or via
    # expect) because they rely on vt100-like answerback support, such as
    # "<ESC>[6n" to report the cursor position.  For now we just run
    # the command for a second and see that it tried to send some ANSI out of it.
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/tz", "-q"
    sleep 1
    Process.kill("TERM", pid)
    assert_match(/\e\[/, r.read)
  end
end
