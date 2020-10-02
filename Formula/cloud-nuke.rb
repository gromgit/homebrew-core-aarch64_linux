class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.21.tar.gz"
  sha256 "0c199f875f7acce3d821b96523ca7993b8158c924df2dfd9af7f2f80f7d24582"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b26fbf11f8fae75751eae2ae1b0d55ee03de49d2311db8dd0c8e645d8dd5f0a2" => :catalina
    sha256 "04962cb1ca59f14851401a293daab3062da9e7d65c62786db1358760a8cbff05" => :mojave
    sha256 "d1a11c856022022e3d256e2b8bdec34de5522398f74ad4da8faeaa7a07fd0e02" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  def caveats
    <<~EOS
      Before you can use these tools, you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_REGION="<Your AWS Region>"
    EOS
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
