class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.16.1.tar.gz"
  sha256 "16e2a04e5c55c5bf587c42ce575c9bc571530aa11f81cf30611a84d96cbd7924"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f2241591ed8f5092464488efc3315bb0ecc0d3072a7fe80a3f1e30ddae4f461" => :catalina
    sha256 "9d8e031d394451c661b3253f44d5c7b7e591d29621e7168c3715edc0898c023e" => :mojave
    sha256 "6c61ebad20e3ea6711072c5a257c0afbf8d70e864e93357f1a02b7a2da1b7a45" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")

    # Install bash completion
    output = Utils.popen_read("#{bin}/kops completion bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/kops completion zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
