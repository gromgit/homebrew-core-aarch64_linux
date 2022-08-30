class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.10",
      revision: "7fd96294a5f77a9377f4f7b0a47febfc6e857dde"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "958cf3d119d2b32b9f09182f0edb95ece52b2b10b0a4be53e33665317e17a2de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf0c87bbebf54a1802561b5a497bf5d6fca3ce18937877774d500ad324d6c87c"
    sha256 cellar: :any_skip_relocation, monterey:       "cad6a64c927d4ecb7bb7013980d7631238e5d2fe7a565bafd44aecf9fd5565e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8ae1702001dced1eb2738370089342d101af429bb059ae02f09396c989cad51"
    sha256 cellar: :any_skip_relocation, catalina:       "e5f2759109863627bdf0cc17ce92839ae2af22a919e7b83d6a195e81ef272024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a889984ed93062b4cca1531e5f3198ad564d4e5b9a41ead420db1605e02d2a9"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=v#{version}"
    bin.install "_output/glooctl"
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"v#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
