class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.3",
      revision: "ee506c559ac1f02577229db9a9af962167e5736e"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d6aab394b6067ae6ab308062722bae30880e7d1192afb380f79c7dc14f66132"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72a88f4776e97f230ab2e2714b1ba3af3edbcb373b71db1450a246f68eb649a6"
    sha256 cellar: :any_skip_relocation, monterey:       "b7bdcb7434168890b36d5677b07e87fe717629e6f3866ddb24de2c31d21bf6cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "81bbac690558fbb7755458cff058a9d0c28b9148ac9f56d9c99c458dd809beab"
    sha256 cellar: :any_skip_relocation, catalina:       "0511e9e139287a731e44d3dea9cf8883d6eeef343cdf8050ac80dfe29e05eadc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031f41e9bf61455ea304794258fec61c020b7fcdcb24cdac72afaf0e4662030b"
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
