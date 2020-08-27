class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.7.2",
      revision: "c342d3fc9c9c9f0d1c18254b6ffa1e106984a76c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b470eefac83f77d8d3df2bb10d609fc7ad4fa28f1876513f784fa7b3270fd2e8" => :catalina
    sha256 "b0e947fa1de185f637f1455612198dc1b420897296c09116d17febe540eb241d" => :mojave
    sha256 "77bb95169e412d95f25538a9ff12f234a024f11c3d39371f737304a0cbd2ab09" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "cli-local"
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
