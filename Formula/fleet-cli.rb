class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.3",
      revision: "c17a2f2cd69df7ac028ae9c0dd8ae3ea1e492f2b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0c5dfccdfc07605a1bbefdc16882745a22201f18dca17806bf8e542719827459" => :big_sur
    sha256 "6ea8c0ebbe4b2990e4c8bf29582c1aed50b4649513eb0e7e42ab4bad33cf6203" => :arm64_big_sur
    sha256 "03b4414cb80b9bf95a4dacd9a432f04d240a21aa00a26a2df7ce47342df7ed47" => :catalina
    sha256 "e8f8fadfaee6bc9d893454aa7035985ce652bcb25448ce5fd50e33ac45d09acc" => :mojave
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp
    system "go", "build", *std_go_args, "-ldflags",
           "-X github.com/rancher/fleet/pkg/version.Version=#{version} -X github.com/rancher/fleet/pkg/version.GitCommit=#{commit}",
           "-o", bin/"fleet"
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
