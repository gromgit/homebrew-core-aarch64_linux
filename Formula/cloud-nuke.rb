class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.4.tar.gz"
  sha256 "99f462aaeb18fe1194fc8073d985236f090b4b1d5a7400050629aaa784bf4dad"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b9e5a5233d7c282a4d93a9a6dedd1aea2da4c1f4f16983d10d6005e682584de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fdfafb6a80e9a22ee3849d49e4a4cf35bcbe683116fc0ef25c6aaa27e93babc"
    sha256 cellar: :any_skip_relocation, monterey:       "f5822bfbf0fd5621b03ce61458d47c10622c1a2c26812cfec83e25b53d1a167d"
    sha256 cellar: :any_skip_relocation, big_sur:        "64a599dbcaa11296323a0c8282b374dbd89debd658e8f1502a8a95c698c066b7"
    sha256 cellar: :any_skip_relocation, catalina:       "80a6b42190c1f9494a928ba98b54900c3e90f4b9f797aa4dbef7c11960a2c39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6fa18ee63d68d23ab309766dfd670942c29640b49f7a0f1da333e6b11a1dfd9"
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
