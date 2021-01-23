class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.10.0.tar.gz"
  sha256 "9ede2b77b451417e36a208cc5183a21f0420f7b6a6230146ba7d76ab34b99bc7"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e40a2343bf999585fa4fcb1a1e9b801427e921c098fc3f7e3026c071a0e72520" => :big_sur
    sha256 "dc44080f2aa9eed1d51e4ea8e9dcf1a418a36fee88327b7a9770ee24dc3c2787" => :arm64_big_sur
    sha256 "e5ba99b5f14711e0dcb121a992d74c5ee6c6b0468b27e5200bf796d4987e13c0" => :catalina
    sha256 "d52a780ad6af93a2a7c480a41c5178a461b9966ddc1adb66adde8ff3bce15238" => :mojave
    sha256 "423ea750ae8589d1a199847f746d8e9b5b1f1d81ceff3a9dab2d63f161532588" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"kind"
    prefix.install_metafiles

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "bash")
    (bash_completion/"kind").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "zsh")
    (zsh_completion/"_kind").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "fish")
    (fish_completion/"kind.fish").write output
  end

  test do
    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "failed to list clusters", status_output
  end
end
