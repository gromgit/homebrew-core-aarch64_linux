class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.5.tar.gz"
  sha256 "9292877e639d1db7a13dd3bde83fa2d7a894d50a6dcd7c363d8ab92bfc021e58"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0851e9b640ba65d93123a8c6be0deb4f0dd39f41e8311ee16343a3a0bb2a500"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1a18d72c852f596626bfa2d98b0f03d8cce152868d0e74586f99dc020d7daab"
    sha256 cellar: :any_skip_relocation, monterey:       "2d3b3ccdd70d029f89283c3d73b3ffdbcd8b5863cad15d05da21dd50025cc340"
    sha256 cellar: :any_skip_relocation, big_sur:        "00c98aec8d791e864a69dfc36ad73e55df112f06c9d3a2d0581d09c8a55c7931"
    sha256 cellar: :any_skip_relocation, catalina:       "56ca9c18cb08d91dd7d3855f9541cd8573debdeb4c6d1c0d213593112728e8e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a45c1c7961bf561e18c9a04da1a40b030cdb9e7d05aae0b73b587eb9e6e7802"
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
