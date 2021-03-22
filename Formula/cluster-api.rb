class ClusterApi < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "fc7c7eb07bce70505721c8bc82ff4b8f111172cdfef94964b7ceac82e45faace"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ceb42ab35b40b83f84a6aedafff4d413fd0c140b28fd4fcf1849de9ae7a7700"
    sha256 cellar: :any_skip_relocation, big_sur:       "edbd3802a0e7f7049e5335b5a25e6e53ee3234b1f3cd3258d73ffbc0b70c2cf4"
    sha256 cellar: :any_skip_relocation, catalina:      "d390638eb576b92c2c0c1065e6f989c60d1ca4f98210aa5f6ea8728da6c130bc"
    sha256 cellar: :any_skip_relocation, mojave:        "4e0de5631174042962b9739df985d18d6cea8d50de72e436a48a9a09581e42b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"clusterctl"
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl 2>&1", 1)
    assert_match "invalid configuration: no configuration has been provided", output
  end
end
