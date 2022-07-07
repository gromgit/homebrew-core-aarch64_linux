class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.20",
      revision: "8e273dfabf31e1502150bf3196cdc1bf40d0ea50"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "687f62c8c7fbfbd6a0864169cac8c84b7505f46f4b50a753b82c45a4e34e6bae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf4da927d865276c33fd7eab4dd43048812026d5fbd98bcce4ea8614bb5ec603"
    sha256 cellar: :any_skip_relocation, monterey:       "f231eaf2a3b19dda2b9be690e2919bc7eb28fa0baf4d6b9dccbbc66f1393dc91"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d5ef8f62322c489e6f22c72ab1b51bf9b256346b26436c518a7e106e18a8884"
    sha256 cellar: :any_skip_relocation, catalina:       "b159b325028824aa55e160e15952f9c646e51941b0df0556d595c4e0d41ce4fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a7e85ee41f1e083e29957894704aa67e1ab84d72498788b8da713e312c8c49"
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
