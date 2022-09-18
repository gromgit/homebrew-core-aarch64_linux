class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.21",
      revision: "9bff069f7fd76ad44982a886f64f55cb5dd5f5da"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d55d592c3745493af107a87b38cbc5d21c9ee6d20f7a9d813464ac870ac6ebf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e416044129ee0a7db39a7f87de4b12084b39cff57ca3fa10f88add48f51dc6f"
    sha256 cellar: :any_skip_relocation, monterey:       "3f503ae475a53ee4c3bef654ee835e9d6978f6cc7c890d5515f7197cce2533b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebfed9a62e982e7fd1b5c6b98ce0dd1f9f87c45a90d599e41b52ace6dcc61659"
    sha256 cellar: :any_skip_relocation, catalina:       "a505e7b1613643882957fafb7eea1a8e417f2783748996f0650644689c32f68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9fd7fb8d9b41febc1fa36d05d854795b7e4c33e35d91f14fe92ac6451a47712"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=v#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"v#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
