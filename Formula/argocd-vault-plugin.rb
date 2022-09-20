class ArgocdVaultPlugin < Formula
  desc "Argo CD plugin to retrieve secrets from Secret Management tools"
  homepage "https://argocd-vault-plugin.readthedocs.io"
  url "https://github.com/argoproj-labs/argocd-vault-plugin.git",
      tag:      "v1.13.0",
      revision: "6866b7206719e9b5b2ea4d7cb870e18f76534637"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c839cb6200ba08fb748b78286f8d195eae6cc013f1a9a5a734aa32e3a329fd78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c839cb6200ba08fb748b78286f8d195eae6cc013f1a9a5a734aa32e3a329fd78"
    sha256 cellar: :any_skip_relocation, monterey:       "cfe99a49dc698e37c643c608f790659fc2a9eb9f59ec6a25783fa9fb000d6989"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfe99a49dc698e37c643c608f790659fc2a9eb9f59ec6a25783fa9fb000d6989"
    sha256 cellar: :any_skip_relocation, catalina:       "cfe99a49dc698e37c643c608f790659fc2a9eb9f59ec6a25783fa9fb000d6989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45875b475ff173dc1008faf113258ecef41ec273d5477e742c79b7d45637011e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/argoproj-labs/argocd-vault-plugin/version.Version=#{version}
      -X github.com/argoproj-labs/argocd-vault-plugin/version.BuildDate=#{time.iso8601}
      -X github.com/argoproj-labs/argocd-vault-plugin/version.CommitSHA=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "This is a plugin to replace <placeholders> with Vault secrets",
      shell_output("#{bin}/argocd-vault-plugin --help")

    touch testpath/"empty.yaml"
    assert_match "Error: Must provide a supported Vault Type",
      shell_output("#{bin}/argocd-vault-plugin generate ./empty.yaml 2>&1", 1)
  end
end
