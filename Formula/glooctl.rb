class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.19",
      revision: "5538576de8c66b9eb1c4bf7c4a908ec935b64415"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2939b6b1970cf416518c6ce26ec2179852e10a6bc12d559ec842032c5f473ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f0bb826ae4975c654c5e4ca0c40654baf49da2b335152d084f39d0957db6b8d"
    sha256 cellar: :any_skip_relocation, monterey:       "46ec4e4b6f255cbacbf3fe1da9cc08c5d21f04fa4512f1a51fd26785f9a85606"
    sha256 cellar: :any_skip_relocation, big_sur:        "1208aa977acdc0f642b2fd626c3b0f18b870d24cf41fd0a77ebc9c212ff3a88a"
    sha256 cellar: :any_skip_relocation, catalina:       "72333606e2dc069898487e4e1c5d0f65907794d84907c2c4e09572711df07683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4735b2782f0f10485e438d18c05abf3702bac5a32b56a8c0dc90e6b56f277b3f"
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
