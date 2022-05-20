class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.12",
      revision: "4f23eab7906ddf9e8ee3ecacf192250c6612ae97"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9662037c629d8e309c0fafa7aaaf0c2d26729e1afa4e027a192c5cb478fe293e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2571b6b38b7e1d5a56ff2fbd9d80ee80ea9bc5a860d71493e72d6a7962dc804"
    sha256 cellar: :any_skip_relocation, monterey:       "5c5ea530e81eea30b0b5d8b483edbbf36c6317384357bd69520f5f90f0604c54"
    sha256 cellar: :any_skip_relocation, big_sur:        "1acea2bb58eedcecf6e3e7ef44df3d51a2acd7e5f25aabdbbc9a1a33248699ee"
    sha256 cellar: :any_skip_relocation, catalina:       "342421d4fca27effd73c4288a721dcb794687c99e114237ffb80900fb6bff392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d8cdb70e1f2729acc03ce9841d6185ee8e45f00252047f266a93bb242c125b4"
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
