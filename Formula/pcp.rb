class Pcp < Formula
  desc "📦 Command-line peer-to-peer data transfer tool based on libp2p"
  homepage "https://github.com/dennis-tra/pcp"
  url "https://github.com/dennis-tra/pcp.git",
      tag:      "v0.4.0",
      revision: "7f638fe42f6dbd17e5bf5a7be5854220e2858eb2"
  license "Apache-2.0"
  head "https://github.com/dennis-tra/pcp.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pcp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "044ecd690cfaddef62eb43d13533aa906cf44a70beeceef1d1999f5a500e74a0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.RawVersion=#{version} -X main.ShortCommit=#{Utils.git_short_head(length: 7)}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pcp/pcp.go"
  end

  test do
    expected = "error: failed to initialize node: could not find all words in a single wordlist"
    assert_equal expected, shell_output("#{bin}/pcp receive words-that-dont-exist 2>&1", 1).chomp
  end
end
