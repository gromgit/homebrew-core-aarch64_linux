class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.26.1",
      revision: "e309c28d260b4e9d4b0ea02cfb562126baf9b886"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b9755e789109e5e1e6c57daacd06ea43cb494d168cd3140f8bb1fd2ea0d7bff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a944e30ac19106d11146346434178d02dd3bf60e6fe0ddd33184200e3489eb50"
    sha256 cellar: :any_skip_relocation, monterey:       "8b6c45a62b11b2c31b7d0ceea9a00f5605f018067d8737fddafa5f38589b8714"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dd9a32fe20f9f422ff3f0e0443f570fba6f1493edcedd8f4710965b7e3e043a"
    sha256 cellar: :any_skip_relocation, catalina:       "202a53203d6b3e33475936f8266238ea190f5c5ddf226901c218b34a8b666336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5bba991d8fe0a86595496869d0a7ed89891b0800cd073260ea274c51563f829"
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
