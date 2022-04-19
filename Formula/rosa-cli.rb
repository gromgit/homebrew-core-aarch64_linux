class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "10b0354f6f7b76d661505dea09fbc3e296a6abc906c9be61766f67de5ca8d0b8"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec54f71899092bbccefc8afa16d222731ecc20eaf83cdbb16721ff867d245ab3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89c76600b2266836b339a52549dcd597e696b8aacbb976417e8f7c1bc96d7457"
    sha256 cellar: :any_skip_relocation, monterey:       "ec7bb792b15ed905326dd55598b577bd44170a7899dc1e69ae8502d423001b56"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f1eeb956816b7ed0015951524800a7b2b20a41f7125f9b871dcbe5e7a446d39"
    sha256 cellar: :any_skip_relocation, catalina:       "90a8fdb5ca95130f2d1eb4eb15b801477463bcee34e57ed2b6715846f94dfed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94fa9a3ea856a8ecf2536a3ee776da4fe7d35f63c7b30c8106700731a7bb5bfa"
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
