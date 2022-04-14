class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.23",
      revision: "be5a8cc594cbe860055ede8ec36635fcf36ae283"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7269cb0d535f6b4bbaf2d57afe38dd4a28df1123d37083dab51c34ec2aa19de5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42af5e98b6a1da670042f862cd1e1e07db583e0d53726b6f463d75b5ba8c3558"
    sha256 cellar: :any_skip_relocation, monterey:       "2be3dc20a0028918d2f9a118ca1e15ed6f413e3139b27f7d42f01c8c4c05973b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e2b2a74be6357d3d586e1187d11bc2767348702107552000fd0c83e9b5ae959"
    sha256 cellar: :any_skip_relocation, catalina:       "933f97d390d179ded570ced2152fa968a1c28888578a55406eee089e1cee70b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a23ebafa6436123b8393a4d2f158179824d489ac3bbd61a1c17f3420a9ca3dc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/cmd.Version=#{version}
      -X github.com/alexellis/arkade/cmd.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    (zsh_completion/"_arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "zsh")
    (bash_completion/"arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "bash")
    (fish_completion/"arkade.fish").write Utils.safe_popen_read(bin/"arkade", "completion", "fish")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef _arkade arkade", "#compdef _arkade arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
