class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.26.3",
      revision: "0893f13b3ca6b563dd0c38fdebaefdb8be594825"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8c8d266d91929e73027a34a04fd473d1e32516c2bcb5c9b53b35115732782a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f22b3ecd49b8e5e8754c84f5a16825baefd946a591d83827e0d655b9f815e36e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e8efc00504a519ce601a1c8eda322e58e5bfb3f589ea25da858165e1555e3b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "14b89cef3a87c04aa191b5d6d06c8eb27f60d6170c62e6b2e84e6e21d459085e"
    sha256 cellar: :any_skip_relocation, catalina:       "3e226b7527ede770810c283b931370636135a49659af48013364b71da9a55646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f26734153306cbad8fb5f0c812f2618320319c8eb75c8b3e315f48f80c193f"
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
