class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.5",
      revision: "718ed4cff8dc334ffecbc4021d6ae4f60c84b9f9"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "867a4a233c2e3b701c804ff65f59875c7822186aabc75f3a83fa1cfb74dd9748"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7121ab9109b8baf7646a39d78059ecb87525884b78f6cdf394036a600d197058"
    sha256 cellar: :any_skip_relocation, monterey:       "e3ad919cdf0cc73e9ae1cbcb30bda978f48f8e12b9c675d12c3eb0eb0c7e5084"
    sha256 cellar: :any_skip_relocation, big_sur:        "e570609f4d2613fe2c008f23641aba9287a82e116258006e616389c827441db7"
    sha256 cellar: :any_skip_relocation, catalina:       "a7a4f7587fea7c9877eabc87f2aabd8fa891ca5495911202eb31e8906d30cc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d5cde7478103b73451941db2727159f0cc70bdfc89be4b07e432fe5278e7fd"
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
