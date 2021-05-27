class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.0.3",
      revision: "8d2b13d733e1dff7d1ad2c110ed31be4804406e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e017f9df8906d3022c34dce1e2618f45b9716187a5d2d924534acf1f64c476db"
    sha256 cellar: :any_skip_relocation, big_sur:       "f0186dc2e98e08cb96e05bde75390965c05a4cc1640d1ae781f5aa01613bfe3e"
    sha256 cellar: :any_skip_relocation, catalina:      "711358c0e41e2e64b7558ea05982d3ce3c9ace9a12450afbca61e25cdfdbf76d"
    sha256 cellar: :any_skip_relocation, mojave:        "666fc3545f23d9d636b1e13e3f71810e4d4626bc8411b781e4a3192ffc7777a6"
  end

  depends_on "go" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "cli-local"
    bin.install "dist/argocd"
    bin.install_symlink "argocd" => "argocd-util"

    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "bash")
    (bash_completion/"argocd").write output
    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "zsh")
    (zsh_completion/"_argocd").write output
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    assert_match "argocd-util has internal utility tools used by Argo CD",
      shell_output("#{bin}/argocd-util --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
