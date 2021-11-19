class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.9.3",
      revision: "444d87c248b459ef8b91a6b8262278ea4f2c8f30"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7390d875f98f61e27fd6a72849887a18fceb6a38a5da9255618d7fdf98e47092"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ec03196e803b122297dd645956ffefd8237e00dfc8139a33eae24492bbfc913"
    sha256 cellar: :any_skip_relocation, monterey:       "4b305a209bf9c5be50cfb6dbf5467002fb6dd46e51ab50d0a15c626b596e46f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9db1f3db66ae44f0d19bad8263c22cdd10627843d33d128e0b89af1a9047b2bf"
    sha256 cellar: :any_skip_relocation, catalina:       "510daffabf1528da2fa6a4f88da36721b3dca6aade0f1afadcfe734e815ed116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a46ae4b66b2f5c2d9964876a9e7031c4ad136f6e377338d2195f6c114dd390"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "TAGGED_VERSION=v#{version}"
    bin.install "_output/glooctl"
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
