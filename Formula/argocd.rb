class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v1.7.3",
      revision: "b4c79ccb88173604c3786dcd34e83a9d7e8919a5"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ec237158d857bfd2197d16794a508fbeabefb71353137c69469be23156b450b" => :catalina
    sha256 "785012592f4dd8e2cf1cd85035720d8bb56c5bd75f595b9e79a6dc18f4218bdd" => :mojave
    sha256 "1c19168dc4a2c3ba8e25114f9c531d9f3a467ffeaa7d12a763c8b8893f558d2d" => :high_sierra
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
