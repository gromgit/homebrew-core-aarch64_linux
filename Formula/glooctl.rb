class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.18",
      revision: "4c0776561e3272fe877178a2c421502dbd795726"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3364483c61ebba7937b998ba2b1956292c2b7fadac498cba6b76d9c4065c5e23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c5c5ac71dc089ee42d685ada287370919c0a78123ca99dfea1215dc5e00c282"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf47393be64b6855fbb724f31972f60ce5b380d28c52f0e21bad399a51cc854"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eaac3cd4d61ccbc560573f6eb4a89c5aa622d6c1f4d53c80bde765a66c2c25c"
    sha256 cellar: :any_skip_relocation, catalina:       "57e42bbaea9cd3d837fefab0185b01199e577e626af8f80488686ced29aadc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22b3a9e9d17b54c46cb92356c2383d4cdd8fe48283ce6972bdaedb0d0c5160f0"
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
