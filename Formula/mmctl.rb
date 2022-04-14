class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v6.6.0",
      revision: "7b4623c434caf6fe9f315e8cedec3dd4f8e082fe"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa237cdb088ed8f6ff2f6301b927e76836cc48d8424f9e9332c067883f45f28b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acdc2a642b91bb6163714ba0e555e9964aaecfc57cd43ff013539c4bc67fe8f2"
    sha256 cellar: :any_skip_relocation, monterey:       "fc955ccc87eef0533fa13ff41ec6c892553a02376a0892a89a51d37a7cef71ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7ddb05c4c0396cfd85472ce686ba925dce4b5bf4699a34e349821df849490b1"
    sha256 cellar: :any_skip_relocation, catalina:       "3cb7e991d39d3f30301c0eb00183be2926a1b10d07f7281570278e039e4a0aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63b65233d587c092ec3a745dd82d811d64ab3c2d980e526beaa343ae98a02ba"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    output = Utils.safe_popen_read(bin/"mmctl", "completion", "bash")
    (bash_completion/"mmctl").write output
    output = Utils.safe_popen_read(bin/"mmctl", "completion", "zsh")
    (zsh_completion/"_mmctl").write output
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
