class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.19.tar.gz"
  sha256 "ff550fe4814a18d6da3b7eb557e4ad9bec61650ea27bd7fb06c0df5080fdf7ab"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e77748c7476928a62c52ee673e91894ae068ae7a0387f21d6d8522443e21176f" => :catalina
    sha256 "4e7c9b182abc5cfba18a680758068f5de1a78f70cae6680c32f3380f3177e3bd" => :mojave
    sha256 "0c8ac7a42ce23baeb715c3d6fd820b0573e553bc3a3e672618def99f8dca966d" => :high_sierra
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
