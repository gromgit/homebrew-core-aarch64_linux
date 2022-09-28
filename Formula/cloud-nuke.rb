class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.19.1.tar.gz"
  sha256 "0379c1d1f88d08017aea9a592ea348836b05ae4060e23f15cae9c0650dad53de"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c49a376b3ce4dda270a6880ad4e5378abf83dda6c751572dfdb3630a01c20274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f111f6f65125461897cc0e881fa2c221b10d9e235ce771cc3ef7803e86ef00f2"
    sha256 cellar: :any_skip_relocation, monterey:       "4f079b65625cd5ae13c2527536d356eff05755f7f77b32130fb657edb8e82944"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9afca21e5348b2eb794b0c89a84b84efd77b9518ccd6cfe51210abe31e2b0bc"
    sha256 cellar: :any_skip_relocation, catalina:       "5d1ffe239262af65ab637221c7bcb5020b5d7a1488de05305c0212e6a9935fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "731a804211a66c0d78e6d01d800b532384b02db0c098baef1942058aa5fbd0bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
