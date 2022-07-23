class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.24",
      revision: "d58a77ea160212b6347652f90c60d518db5b1bcd"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dc907a4bdfdfcc23f01a545cb8986013206654a265b1db808da290caf3af02f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d20bf54cc3feb76d455354e0bd324a799cc2d312bafe2200c6720f44c057aa84"
    sha256 cellar: :any_skip_relocation, monterey:       "02c9900a0e467fb7eab965e6651a78fea389ebb948589532287b697a3b7853b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "80c8cbe8d6b2f016e8261b1c0493c5be8314099119058e36a359c107e213feb6"
    sha256 cellar: :any_skip_relocation, catalina:       "937d0f2133b27533a1151f4267bfea5faa58b7868bd2459591fbbcfe75e0ec95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0c666c0f19215876a5ed77f4cad8104797377a972a84eb62cbf9dd2a978687"
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
