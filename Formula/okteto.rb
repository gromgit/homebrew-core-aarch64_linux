class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.9.tar.gz"
  sha256 "8ae92bfbc437af5b36428a07ace85e08351745152c8b2a87309e57b98fd85ec5"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9ae1063b091e8acb13b10103d0966eea956516df0f99cff40e14a9d7fa131f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "70e9c444a105ac98672172d0902ae3f8853704ce2b3299b07d8029dd3db23585"
    sha256 cellar: :any_skip_relocation, catalina:      "0a491009d2d954a98f518f15ac6d989dec315d1badd28e3a483dceac503e1b55"
    sha256 cellar: :any_skip_relocation, mojave:        "d4b8102fa19160dacc466201773dffa602e15c42c17eef41a84c8598004b0aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c76d149b510f7d5c3ddd6c1d4d8f58117526502669a23175ea7154b95b9a3da"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
