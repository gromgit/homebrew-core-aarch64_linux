class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.16.3.tar.gz"
  sha256 "931e3dd89f059c7191173410250cadb9ad01816efe0169a55b15d222a7911f59"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0457ed1df1fb69159fa793e738e1b5a6098dbf790dc235febcdd14261950ff81" => :catalina
    sha256 "3a247343d4045e5eb41678920ce7dd9fa9c7e704d542f5e9b19c9f98c253d3ff" => :mojave
    sha256 "7553a41988d4333a4d845ddc6d780b2e958d297b5ee360e48283647589d3a0d8" => :high_sierra
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
