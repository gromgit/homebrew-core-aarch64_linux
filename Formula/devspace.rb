class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.1.1",
      revision: "9cd3723afbf14d488a208b0dfb301f9670a51c92"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed08ad36f922bfc7772840da04bdcb63785746e75f64a624d7f80759ea49d9a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98c843c04a6acdd68190ef694137af57fee7d61eda95b98428e4d6690fe206cc"
    sha256 cellar: :any_skip_relocation, monterey:       "fa257de3477a7375fbda4e526d944977d03ef9743cdf06819c4e728013a63de4"
    sha256 cellar: :any_skip_relocation, big_sur:        "00d52fca5d012886d762d853af688e3e75c531010263c5f612ede493831359d7"
    sha256 cellar: :any_skip_relocation, catalina:       "070a72d3f84e7918deede54c840712ea307a7c6ab90223e95f7bd7eb000eecf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa94ee04de7289e284de9f2dc9e54e79db568008037ec113087db01b8910c2c4"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
