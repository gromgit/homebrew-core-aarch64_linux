class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.22.2",
      revision: "14cf6d6ea10423b12809d868eb574a9a610916f9"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b62d3d4c1a956f06c0d588a5e1b40c5e218fb2c657f8c0c3ce3776bcec530f19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d27be3fc96c7eca089decb0b037e34cdf19e8881a3cbf79374949726878c2d07"
    sha256 cellar: :any_skip_relocation, monterey:       "f8bfd561792dd43ab797e70a06fb01d74cfaa3051be4799d07ce2b4ac08a398d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fa3981a0d9d66df61ae06b7fcc6f88e7d4aaeb67470fae8d8f88468806f489e"
    sha256 cellar: :any_skip_relocation, catalina:       "d0780e06a66fd68cbc360479deebbe8f90cd6652c1a748bb911360860fb681a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bc8fafb49ae87a4fd0daaed483e3e1099f5dd8c74ad3d51bd87d971acc1013d"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
