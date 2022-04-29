class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.7",
      revision: "4f534521fb5447ca1311a24a346cfb247fdb3850"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "824031516d25bf933e3a95d81bd4bb428e72af05b00598f2f15eaa9163a9ea59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42520f916cb5bb5db91fb0233cf1ccaca67d588c938e0b5c4982ca65093df779"
    sha256 cellar: :any_skip_relocation, monterey:       "07babf5c3c24949b76277a0e90f7c017d4c3054bdf5875b9db2c8e066aa9dc63"
    sha256 cellar: :any_skip_relocation, big_sur:        "416a6b1a2ba4a75fe1d85f9c10d85ef44d288f67420752a416e20c2e4b30aa6f"
    sha256 cellar: :any_skip_relocation, catalina:       "78c0dead6d661b470e7959532f4b29d9dc7ec50b69a985136572056a3e7e5bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaf4b3ca494bc90199b12b75b4dc00edc74a57cd7ac318b962bc1453c8609629"
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
