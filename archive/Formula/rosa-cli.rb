class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "be19bb79e492426d622aa8e646230609929eab9d71c79bba70ad8aa655226fba"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f113720c500c55c3c4523dbe7d94b22a7727e7cc71251e840a62c0472bd4d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5e2b5733c5c26b3d8a0c7903f0b911c6048dbb4b74067450e247ea02e6a5c21"
    sha256 cellar: :any_skip_relocation, monterey:       "5b1ee2d2df0ad7ba8a60f3fb7a4120ba918af75dddfeeeceb26dc11bf98cc73d"
    sha256 cellar: :any_skip_relocation, big_sur:        "82743cf30dcae5ced3535d886e2927f34ec053bfe77c694a4167069a442fb1b2"
    sha256 cellar: :any_skip_relocation, catalina:       "a0080268246b24da43ce8d09ac4e93341c1d6200e2db93b606f064eccee1daf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cceb41214e4a58bfa3cd55e0660f23f170caac0690dc38e1232cced36cc008b"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    (bash_completion/"rosa").write Utils.safe_popen_read("#{bin}/rosa", "completion", "bash")
    (zsh_completion/"_rosa").write Utils.safe_popen_read("#{bin}/rosa", "completion", "zsh")
    (fish_completion/"rosa.fish").write Utils.safe_popen_read("#{bin}/rosa", "completion", "fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Not logged in, run the 'rosa login' command", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
