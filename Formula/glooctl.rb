class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.6",
      revision: "5bc01ca9e1d63092bb6d9470df8f310c41c3e3f8"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "085c6e741c527948a694cfaf6f22617ec74a6962e2ee327ccde3f35242d5e785"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd6ef6f63a646330e84fcdc01419c1fe5c2972a98a382e26a7f69f3a08b0c5e7"
    sha256 cellar: :any_skip_relocation, monterey:       "a9806a24aa0f39c71ac3031096c1adbce883e35ad96b9b4c160b2d533d289191"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e2df72a6e6c9ccf79fe0b719a92b04b14323a3f61aa4fa3008757ea472ee47f"
    sha256 cellar: :any_skip_relocation, catalina:       "0cab4555ac87c9e66c90c4afd83b6209dbb5dd47dadbb846dedc78698922c6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b339da98679e75aabe1f47a7ac55c0e5154c826a29c8d478bd72ad9bb361b05"
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
