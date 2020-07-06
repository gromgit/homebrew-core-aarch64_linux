class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.17.1.tar.gz"
  sha256 "880414505447ae8ff4b91ea5c75e5de1a532a66f113e51db15b83672c8cb78d2"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a2e48a8f92dff5209aa8caa9621cbc6cee8cfb3cbfdc96f9b2ba0cea1e2bb43f" => :catalina
    sha256 "c4fa884c955ef03b79b75e4564b49b73aaa4c04ffafb4a80d68f00f36124ab76" => :mojave
    sha256 "24fe08bc6a8ac8c19969330a41a32bd2315a12bbd563259710db72e54b4815b5" => :high_sierra
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
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
