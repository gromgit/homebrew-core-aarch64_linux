class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.13",
      revision: "fdc638c5d47da880dacbdb88c3241c20332a7990"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "741452a19c1a9acbe8cb8b507fc3e7fbe6c09cca1d97bf7757c596e5f9912cf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "802e6aff56b6294aa929f1176f6eb98453de97e5d3371f684811dd8ba7b700c0"
    sha256 cellar: :any_skip_relocation, monterey:       "f391fa0a504dda6eb871b9066f5add7b5fd86521352b369fb4c726c05150de16"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb54ea186e7a20891e8656eb351f1cf8d894e234a269d96cf2779af229820be8"
    sha256 cellar: :any_skip_relocation, catalina:       "fa09c34962af3eddc36862194bb1eed7c7792fa6df1d3b78e5e0593b67364730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f05229543253ab07108731c0cbdce68b9ef4e551b9a5f6d588f426a767c61773"
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
