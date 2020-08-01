class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.6.2",
      revision: "3d1f37b0c53f4c75864dc7339e2831c6e6a947e0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c988b2c0db76ae062803b59bd258fe8617700d942802db2e541a19686e46b6e8" => :catalina
    sha256 "9f02374c7445563bb5212f05e4341e6700a5c392f10bc4a763cdae4d2308b736" => :mojave
    sha256 "091dd790ed68a02fca4a2b36aa1df68840e190b7ff6f58bc13a732bf584b68f3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "cli"
    bin.install "dist/argocd"
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
