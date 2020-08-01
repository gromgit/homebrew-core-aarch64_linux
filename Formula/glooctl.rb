class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.4.7",
      revision: "099638fb6ca5eed4cc4380ab96e970df11b56c2c"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "840c24a41a688c34e611e3d44ef184488ede390eceed2ba69850c28ff1db4d0b" => :catalina
    sha256 "e443f91aeee0b94b1db606fe746f871fd4738f2bdd0df64abc0246e31905f39b" => :mojave
    sha256 "84c4f3c237c137805f0fe9a02c2b98845dc11755db2fc5d91a91f54f43a1a875" => :high_sierra
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
