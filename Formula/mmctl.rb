class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.4.0",
      revision: "f10f7f1519dcd82ed0f8f9f00f76ca943ab1f42b"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbd1320569cd7b3eec2f3eefcf28cf6fef9690401e77f8521256c6704ede90bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc4070ae88e101218d661f5d9a031a85f8a2f7e6ccb12f62fcd2267d610427a1"
    sha256 cellar: :any_skip_relocation, monterey:       "56c4f888c26c01e88f613a4706c2f82013fc2bd6d086446c35e9418837453404"
    sha256 cellar: :any_skip_relocation, big_sur:        "da5152ee47e863ceb0c97c3c3644d5ce2b1b870fdcf03ab8f82d30af8f1e5560"
    sha256 cellar: :any_skip_relocation, catalina:       "e1fa9c08ec168ed059ea16ec57d61bcab5d85877294e21b4c00095d6eb66ddce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8611c77034ab27ff7ab18e5dadabfd6253bcfc9489ce03c1521f9411c2ba0e65"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
