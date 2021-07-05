class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://github.com/maaslalani/slides"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "f1c3494ec8d52ebb0351f1722d60ad4f4dd56b1f649130adfe59db8c9ffaeae2"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e507ef2d2bfe51b39492d1b8dfa8761e80c5f21b0bb38e18079ab4cb5e999f82"
    sha256 cellar: :any_skip_relocation, big_sur:       "6216115ce6b26e93b0135b9ee95c210d666ad161a3492906e0472a0882d218a0"
    sha256 cellar: :any_skip_relocation, catalina:      "852462240d514a0bb06afda1f62e55106b45e810f57f2c2a664e74ed9da0bbae"
    sha256 cellar: :any_skip_relocation, mojave:        "abd902e020b83f415970b3efdd456cafdf3fb75cc912c62fd08a68cc180855c7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.md").write <<-MARKDOWN
    # Slide 1
    Content

    ---

    # Slide 2
    More Content
    MARKDOWN

    # Bubbletea-based apps are hard to test even under PTY.spawn (or via
    # expect) because they rely on vt100-like answerback support, such as
    # "<ESC>[6n" to report the cursor position. For now we just run the command
    # for a second and see that it tried to send some ANSI out of it.
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/slides test.md"
    sleep 1
    Process.kill("TERM", pid)
    assert_match(/\e\[/, r.read)
  end
end
