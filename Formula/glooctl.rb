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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52f3af982e4b3ff931c29acfb5bd44202ae0b6b6869b461e5ee849e76b84eb3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af0af6cc19db62a42848ca0d937aa61aec3565faf2c32280be6e95064c85cea1"
    sha256 cellar: :any_skip_relocation, monterey:       "8512786a23aeace0d794b307c7362316bf0640f101c1a920d60bad5dd0eef618"
    sha256 cellar: :any_skip_relocation, big_sur:        "29e2169ad447c5c4513260c0096570bad16b6ba3055cf7f918c3032a2087095f"
    sha256 cellar: :any_skip_relocation, catalina:       "06e7d80b8e4929e7c36c470ddcfc828c3134bf6b2eaeeb4485684ee5b636f6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3448d8c031e2b57e6c8479e7698849e6de69af25c201bf0336c7621025be3a14"
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
