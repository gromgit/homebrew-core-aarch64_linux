class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.7",
      revision: "6b6a490c73af8719a56e1c4a8dec92a6c2466dce"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcde302a5e1ee52de309a2015d50b6590546adc04a04c22d4800cd166f9b44b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b14ed68d3728d312a9fd9dd1fe3ca1eaeb69dd6bbbdac38a596b127d5437088f"
    sha256 cellar: :any_skip_relocation, monterey:       "e906a19989e4800013cd4a9bc3e26fcf4d4a71252f4161f358bca68b952f5175"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9e4ce8de253624bed0e644508ba5727ddcc4d6fe6271345970ca19e111e7509"
    sha256 cellar: :any_skip_relocation, catalina:       "f33aa99acc262654dfd9796337484c7a8c9f23cbe4408878f27572efbb1dd581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c3a4e660f7e3c836c144a7b11d53836082ec584937bf1736c2934a2f57aae86"
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
