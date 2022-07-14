class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.22",
      revision: "2a526828b5fc7b685ca40a2922ba1bad83764253"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31e11eda4d6a4dd02ca5caf93c2cccced9c8eee095897ca4f8eac0395f76749a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1287bc0cc090ca98a189a3d0c5b0503fc152eae4430f098cafb9fdb130093368"
    sha256 cellar: :any_skip_relocation, monterey:       "8e51fbdbd4abbe9feaff3560abd795e643169128e098e056c3561116a6a1c7f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "49142275de6804015024fdee11ab2f33e4da4e48b9d819c106097af6efc64f7a"
    sha256 cellar: :any_skip_relocation, catalina:       "8193fda4c8d871f6d8ec37c8b206636ee00e7286270a397b948e27fac6835f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c00d96826fb51a36813a4aca6ed32b6cdb2e1b9d417178eff8ecc8852872ff8"
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
