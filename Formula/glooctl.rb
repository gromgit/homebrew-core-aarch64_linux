class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.22",
      revision: "7edf24a270f9a9abfda27b53094b3fbdc8e11a65"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8bf0b8a04042e5c84eb5d1fbfc62f1d1c55ed6d297a1d8c4575407ffb7f1051"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40e9aca76f60ed1e45f679bdfedc04315be464b24a8f97fdb0988bcb23c6b6f6"
    sha256 cellar: :any_skip_relocation, monterey:       "8a980eeca0aad38ddff738b10f50d67299c09b1da46d0d819f1ee3551a01eb35"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce6b77669ae310ad725e038bc3ab5cee2f32c929e235359a41f33f628ff56e6b"
    sha256 cellar: :any_skip_relocation, catalina:       "b679a43c78ad03accc3683ceaf2fdfd90089846e300fab47609a0f59b7c75a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed60c2945b6285ca6d8b511435faffb850b0bc0394157b123223733f6f9dff55"
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
