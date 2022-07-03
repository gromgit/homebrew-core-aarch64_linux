class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.21",
      revision: "14862f3709dc8dda10f749b6415fce0178111a6d"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "371a26bb1d1775114722361bbc37832d7ca3451d683778e5069628d7bcb2162e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb7e00632465f9bd48a933463816a489b0d2aca756d77888270ce4a52570f08c"
    sha256 cellar: :any_skip_relocation, monterey:       "52ac2524e7fc367fde511dc4cb9f4262b4bf59514f0f7f31f0674711d21e576a"
    sha256 cellar: :any_skip_relocation, big_sur:        "eae6c520a89fc3155f4849c549cb08ecbbfb56f89d8976fbc49c803bab7504e3"
    sha256 cellar: :any_skip_relocation, catalina:       "98460cffb032685bc4ad87f09a105bb80f1f69d2f97afd644acb8c420452a174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d45d4a780a7b6c1e90152b84cbe0aa0bbd3870c072051e1688a4ac6514391977"
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
