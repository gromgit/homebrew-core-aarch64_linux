class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.23.1.tar.gz"
  sha256 "4bef36390f9ca2f77c8910e969c7236cea7608f211fe46f844d791955e46f49a"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fd2207b2a1dbbbe19da1b7879207a24c1dd2a414e9281081cfb2dab47beb1ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "757ede732a275ac79be47dd332717331f7b81548b0a819c1e4621b8b4bd2bfcb"
    sha256 cellar: :any_skip_relocation, monterey:       "8b04413cb9d2f6ce258e13cd686555015e451af48cf8771af50d10490c0adf00"
    sha256 cellar: :any_skip_relocation, big_sur:        "4aecac727c23a9a90eb280d73d3a1fb67d281cc49972e41b3c002542e294fc12"
    sha256 cellar: :any_skip_relocation, catalina:       "087affa15b16aaf0cdd56eb30073f54f6d2f7a6e711075798ebe86a6a7075efa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e828fac606b18b171bcde63c6e6a1c3b4a5d23a8b3bd5725209679f8008b5d1"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install "bin/kops"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "zsh")
    (zsh_completion/"_kops").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "fish")
    (fish_completion/"kops.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
