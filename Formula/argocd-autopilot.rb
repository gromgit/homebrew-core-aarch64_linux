class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.2",
      revision: "6875c3cec6f58b26e29fdddf86377aacfe63eeff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c69798c742f7a865d8d2e7f99c8474ca25a7b734d9cdbcfcf6f53b32724b78d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "016f4775b6d7e2af2b083530dea1f2d8c2837d22aeb83155ab9335c08fe59339"
    sha256 cellar: :any_skip_relocation, monterey:       "b516a657f9741453af0cd5ec7499e5a59cea6e2c3233320c3f5d22a2cf12e612"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ff24d79be0f8e181d93e35c7c20dead48d42bb77e9d091a80b79db32f8b8d34"
    sha256 cellar: :any_skip_relocation, catalina:       "61a45a60c5fe2f249c490d8420fc92a0ae0895a86542a8dd03b876842cf3bc05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27fe99e3d341ccad86d8c65a3597b0d9809ae3c14f45b315dbfe30fd64ed54cb"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end
