class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.9",
      revision: "7c18dfacc60e1b82262721d58a7d23f022d995ac"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebca5a001251db68d2f6d626ccf4904e755ad65756345fdf52d7b57f0ad3e981"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f5ef8583981a67b79d99c48fd6eae7165780312f4f052ded55a900729c9da75"
    sha256 cellar: :any_skip_relocation, monterey:       "542d7685a36f50f9bf42c49473e9cb94d37e7f552f4379f07e535c0acf282191"
    sha256 cellar: :any_skip_relocation, big_sur:        "d34ea2734a013f5942d3f3d8f8e957022014dc9eeafb4416f8ccdd0264d31d14"
    sha256 cellar: :any_skip_relocation, catalina:       "5e847f92d830717dc8e3351bc6bcaaf03cf2af067b8f3a48053d82983bf65e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "859f56e3c4eb180f764a4f89f1b6c82973bdebdd33c91d2186402ee55d642064"
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
