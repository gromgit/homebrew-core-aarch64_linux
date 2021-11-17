class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.1",
      revision: "83b5feeb37805e2e6950648b4551845a9b0d86ed"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed19b0b83e2141f15596835dd29e43054503ad6ce2878488db87c5e6dfbc610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce6767a0082e1fc0d8f78a33a9b03556d60e471ef6034a5cf0663e624f173c1c"
    sha256 cellar: :any_skip_relocation, monterey:       "c18f732a70105257544944ee3b0391bd45da3a3174877ab2edae99c8adfa9cda"
    sha256 cellar: :any_skip_relocation, big_sur:        "1404b82726ce01acef518d6b62ddaee03750d1fc2fdb1b8b125701182d7722f1"
    sha256 cellar: :any_skip_relocation, catalina:       "4511a0e0d839344695d0c50f0d59cf7196defc59ec10d43b92ce325be6388f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d31b1657d59191e29dbd84e29bd6097f9d1c4a36e1f9c32e9148adee97f39ef1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args

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
