class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.5.tar.gz"
  sha256 "9292877e639d1db7a13dd3bde83fa2d7a894d50a6dcd7c363d8ab92bfc021e58"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cloud-nuke"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d108b61c45a8f2ab66892958f89a26c2222e166b0a9f5b127bd1409ccfbe8120"
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
