class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.6.2",
      revision: "4b2bf039f6f04cc02cf89dae7e15f8bc17b2ad78"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/kyverno"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1803375620da6de543323eebec52ab601c71cd7647e2f32751ac0239c05c92ed"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    (bash_completion/"kyverno").write Utils.safe_popen_read(bin/"kyverno", "completion", "bash")
    (zsh_completion/"_kyverno").write Utils.safe_popen_read(bin/"kyverno", "completion", "zsh")
    (fish_completion/"kyverno.fish").write Utils.safe_popen_read(bin/"kyverno", "completion", "fish")
  end

  test do
    manifest = "https://raw.githubusercontent.com/kyverno/kyverno/1af9e48b0dffe405c8a52938c78c710cf9ed6721/test/cli/test/variables/image-example.yaml"
    assert_match "Policy images is valid.", shell_output("#{bin}/kyverno validate #{manifest}")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
