class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.2",
      revision: "4beb4e1e057e97278224ae4a1cfab06c997383ab"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fdb176da518c8ee1be265da3f44946e3136c4b4cb856629d461be947a94fef2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c750d4a45914312cf5f7f878c5120461b6ebd516430537527375ae751fbb05d"
    sha256 cellar: :any_skip_relocation, monterey:       "0dab65c30c6bf0c4bc449feac58426c4822e46f083d106a1911bf9339cf3befb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebb8c17bde620d36cedd49a56d35e7f82a670ad51c0010e84309bddcd6fa1b15"
    sha256 cellar: :any_skip_relocation, catalina:       "76cdd89d90318656c2ec725ae32d8eb0f9b7b1df8c5a080bc31208bd33247d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce64562b2e64b5ad95c6f0c8e4f646e8fb246fab23a2c1d8235701ce4bf8c6c"
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
