class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.25",
      revision: "71a254bd85ce43e317b0f446cda9e13b80d05ff2"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73271a6f3f4f452a3768f5849847323c700094a9687fbb917e20fc53a385865c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb4c77903afe54270f48622b0b63732fad79045b38d0e0d9b6ebcaff4f6d106c"
    sha256 cellar: :any_skip_relocation, monterey:       "b4d0004c4b37ef0a14e9a7e27356ba29610c8096bedd92cad630af39603978d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "34a79ace0cbdbd61685f220d3c6044fb43ae4e40abeea1787f08dfff977ac188"
    sha256 cellar: :any_skip_relocation, catalina:       "53bf0eaaa1e149b129343a67d73a3755ca0c257229950ae2648f680a9256cd62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "536758c47a23bc74f994d748af622a85d709081448152a165dbc3ad78bb78d1f"
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
