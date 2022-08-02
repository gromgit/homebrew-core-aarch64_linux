class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.0",
      revision: "775a3a5317903cc9987dcee91a71e7a7bda62efd"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ed622ad4f5b3d8e1841f52aa16db014c029ee95d6ea1c5cd55dfec0fdc77391"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91c3a55546df42ad79513e5d5e303cc8a65195cd313148a78ca114cc9ce8e501"
    sha256 cellar: :any_skip_relocation, monterey:       "1e83fc39a8be584d9cc42eb61fe5f214a8a5b264a1af32a6da97425ffea10870"
    sha256 cellar: :any_skip_relocation, big_sur:        "981ac97583d27beb9263a577165fef9a269d2537257b618085c2670633e030a6"
    sha256 cellar: :any_skip_relocation, catalina:       "05f27bf9d9588f9277f84c50270da78fa222cd0502ab5d16ee9cce9bfe6e1df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc5372e7ce0ed3d849abbf1f00a4eae380675275ab6048836f911b7b0ec74729"
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
