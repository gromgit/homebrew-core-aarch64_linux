class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "d6e70db8760ac1a60bfe2e3db3759d8e48e4855d7779674fd6c16bf5f460dab5"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbef82f49f06e084312ca68d71be1b867e275f7d22c7e3958b5baf17cb84a071"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25215918bc06c9ee051093ccd5b954b4a58467314fc29bbe636b176c2e5c2538"
    sha256 cellar: :any_skip_relocation, monterey:       "82783216a58fd0ec29c1d2c9c8ec76d8a5941f4d6a86411c6017cc2ec3e6f83a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a08960b7881ef65964aac52df7e4c46fa05ad04bf58feac67fe7f9b41bb54eb1"
    sha256 cellar: :any_skip_relocation, catalina:       "2dcb61242096e87fa3ebad850f0fa49827685a8429137672665fe8ac0996fb10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d800c924a261215c0acb8425fb0e27f48b8eed708a5a585417eaee316056d3"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Not logged in, run the 'rosa login' command", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
