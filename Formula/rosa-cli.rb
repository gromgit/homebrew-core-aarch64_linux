class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "5aa0dd276e8e4811227277aa898953d40508832f54dfd6096d13b0d1cc48e523"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9126285fa255143db24e88bf138155290da9d870900c140c92bd46492d276007"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79b0d957c2c81d91c6e98fbb2508ec31af7da84a0ebf1db6151ebdd0d8c954e8"
    sha256 cellar: :any_skip_relocation, monterey:       "2e7dc5abf3b05b7bdd412c186f5d00ec4ae3744bbb883984e6a77dbbf16f376a"
    sha256 cellar: :any_skip_relocation, big_sur:        "264f86936db2e8f0aad1cc0ffcc5738dc14d58ae3de444732d74ad993a3bd8cf"
    sha256 cellar: :any_skip_relocation, catalina:       "249728102740525a0af660e54bf21175b3238f446d01a785691bdcd6a2757e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f07fda5cab6509b94c60877ed1299249f8172f8145ae54ed11f2402be6a2a702"
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
