class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.14.10.tar.gz"
  sha256 "efe40d9fda04faf6c64dc02a1c66cfbc235233812de6889a28751f91da0aefac"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce88f9fd5d671a1a4e1ed9c4545bddfa0e3322ca60d28b9cd1b2f96419d69ab6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4156c54eb5819b1ecaa0f09401b2307f7b0e997e7c240cb31eb82bb95f946e21"
    sha256 cellar: :any_skip_relocation, monterey:       "cd7a5de90c1773326d174c4085b3e0ada129539a8131fc828fefc92998258fc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2919b27188161347f1ba9e51e5517462662e4614aad30a388d23871e786d5bb"
    sha256 cellar: :any_skip_relocation, catalina:       "ec87217d23a9d8720f01ba0f3d72c2bebf037389043ee929bad2584f6ae26963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7b5a075acecfb5d2538a4ecaf74b3b58137f0d4af188db5ccc6de1e887f908"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
