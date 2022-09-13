class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.11",
      revision: "2958e9b7be782d21e8b19bd602f2f636ca5770ba"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f61b86ddd0f1c3225e35b7f931daeeabe5deffe258bbce1fea73239571b21c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bc16fd5058c51af46eff5494458cb6c49c156cedc07172fa166eb6359c718cb"
    sha256 cellar: :any_skip_relocation, monterey:       "e1681db69ecb16f702c34a8c14e642d4a3451c739038a374ab430d4bd9e8dca1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff315a4d09347f9f59e9f87e80d948298365e11f0b0ca1cf8a1a54223dad977e"
    sha256 cellar: :any_skip_relocation, catalina:       "fc8010070bf53313a6c28f8a47ff442e23f3fadbbe3c2cf81448f49cf35ad656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3ce47afc8050294498dd0df7fcf2f7689d9ba369ac105dc599ca037d9321408"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags: ldflags)
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
