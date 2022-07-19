class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.23",
      revision: "e16fca9016665802bf07a4311996d62a8a22bbc8"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36d95f53d1c2a495022216911ef5cb84731c6726d151bc3817c7f0bb0790243c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b37b1022ed41fdb4ca23f02679cacbbf486b5b984c6f481f57a555c4918afb41"
    sha256 cellar: :any_skip_relocation, monterey:       "4009a76b212f8a0be9d3cd7f79f9181b8853273479c6d1a2f618a53299b0c49e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e9eab261ae6272654bbfa221e57b4b8ec4359d7884cdc8e8ff151887ed257bf"
    sha256 cellar: :any_skip_relocation, catalina:       "73cff243b890265cd0fb24d02d12234d08ed310ee8e981628ab2b6866f2f5001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533ad26d8ebf562b40d333ad52887da68839ff9eb8d8ad6c3e12cc83cc002c03"
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
