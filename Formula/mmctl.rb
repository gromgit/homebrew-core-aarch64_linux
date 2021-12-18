class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v6.2.1",
      revision: "8cedc5f3a9ef5e18d6da248bef6b5d576674cf16"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f10218d2009cc34a556064d6bb21813daf261f26a7408253f5e2173c911c30b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b758e8a300e32ade858793c4b0b850716e9550990f81c218fb36bb848849eb0c"
    sha256 cellar: :any_skip_relocation, monterey:       "8b9e178336f51b94f682f4adc1821785c1746fc3fbf78d3a82ea2e1baf530e1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "998167259150655d93fff59c7d41ff1ce7d223694f2769f6647b8170b98b9098"
    sha256 cellar: :any_skip_relocation, catalina:       "8089eac73c76d6b3c8c730891ebf159a1208f0083f18222259d7323a2009232f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebc68dda7e4d56d172cd2083c280e3e7106601678e9dc84c4879b1f712c2e9f9"
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
