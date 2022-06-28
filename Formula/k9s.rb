class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.20",
      revision: "373fd4587b69d5e97eea1319b86cbb68f82a266e"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e619cae9240406742dc6f1153f6de1cbdc05186105d49e79d2e2a9a55ff1e7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09e7344bb75eef1405f3ccf53e1249b7c54fe597820e621087e41b3c09f72b94"
    sha256 cellar: :any_skip_relocation, monterey:       "d0aac541e35f07318efb958260b52f9eeb30a02472ddb0bdcc58787963aa15a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7ae25e1d3df279ea435f7351bffffb802b08a2ecd4f9bca97c9b363bc81d20e"
    sha256 cellar: :any_skip_relocation, catalina:       "939616804628d498e660896ec6cd5f9193e84740f4c486f5ddd20fecc14f4014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcd048bfc83f995853186127ef0ccd14c5227ba6a203240ac6d3a8f27c670fdb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"k9s", "completion", "bash")
    (bash_completion/"k9s").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"k9s", "completion", "zsh")
    (zsh_completion/"_k9s").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"k9s", "completion", "fish")
    (fish_completion/"k9s.fish").write fish_output
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
