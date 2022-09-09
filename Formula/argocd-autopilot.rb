class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.7",
      revision: "33e2451ced3a7e6983d0ac1c2aef548f1790abb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38be98e31635414048a61e8fda2ee6fc69a636d781e47ca485540b3352a0be0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d77732360b0198d59ccbcef1fa7c195f55b78bd04e765fc86f146d21936c711b"
    sha256 cellar: :any_skip_relocation, monterey:       "66d9191d8293ca9c2a7228a62bc80b41106a4cf506cad446f8e85bc194c63a8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6edd91ee9c47e27a3d1e2cff07678746c389308f70e5a485d9165f4067df87fc"
    sha256 cellar: :any_skip_relocation, catalina:       "29729fca615acc6208944730361266c252d303c224758bd4d14f6d4daec51273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622b386c05addac03cea52c0d688c0498d72e59a242628866bc97af7979ead59"
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
