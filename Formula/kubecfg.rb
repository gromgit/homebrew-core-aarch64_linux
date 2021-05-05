class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.19.0.tar.gz"
  sha256 "b908c49e3f449b42b8107351ad9535ae47bc6f7b58c51b0a5e9c81ae7e3aaabe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e11a13820f37cc769e705894e7e11fd2a495b6092075df5daa0fed1f6e2794d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "eac0db5a3b40af567c0cf1032fdb2f9347d6476f95563600865cbf1a4fe789cb"
    sha256 cellar: :any_skip_relocation, catalina:      "cde39f5351689bf133491b63454dae9cc9658a27d2df2ee807e519bddce43ef7"
    sha256 cellar: :any_skip_relocation, mojave:        "608b542658fc450ee26c47f1ff3debe8f7e70b71c73ce430c5730ec71cb72642"
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/bitnami/kubecfg").install buildpath.children

    cd "src/github.com/bitnami/kubecfg" do
      system "make", "VERSION=v#{version}"
      bin.install "kubecfg"
      pkgshare.install Dir["examples/*"], "testdata/kubecfg_test.jsonnet"
      prefix.install_metafiles
    end

    output = Utils.safe_popen_read("#{bin}/kubecfg", "completion", "--shell", "bash")
    (bash_completion/"kubecfg").write output
    output = Utils.safe_popen_read("#{bin}/kubecfg", "completion", "--shell", "zsh")
    (zsh_completion/"_kubecfg").write output
  end

  test do
    system bin/"kubecfg", "show", pkgshare/"kubecfg_test.jsonnet"
  end
end
