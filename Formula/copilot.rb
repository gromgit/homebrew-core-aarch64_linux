require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.21.0",
      revision: "baa8478fbc05c31eb24cc02719bb2faadf011a18"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be836be71841188bd183a63192f1eb17bd1c355402fefc3b50c132003433532e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66294769cb39f4f03516db223b26c4f57efd61b19ed2d477fa2012ea7af23586"
    sha256 cellar: :any_skip_relocation, monterey:       "9461233d7c35e3d418675d02029aac5e44e368b50c436a23677ba7a307dd4d79"
    sha256 cellar: :any_skip_relocation, big_sur:        "3893c599f7522de5d45c998145fb139c4b0a53fb09bc9d0712089a8eb723b1a0"
    sha256 cellar: :any_skip_relocation, catalina:       "66be2794a15ddfe850ae0679983d563d08431b44c6ce9594e96851371a212826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfdbc82b05b7e18e9aa1955191423394d4c0561be4e453fb0c3a36033af1fe06"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    output = Utils.safe_popen_read(bin/"copilot", "completion", "bash")
    (bash_completion/"copilot").write output

    output = Utils.safe_popen_read(bin/"copilot", "completion", "zsh")
    (zsh_completion/"_copilot").write output

    output = Utils.safe_popen_read(bin/"copilot", "completion", "fish")
    (fish_completion/"copilot.fish").write output
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    begin
      _, stdout, wait_thr = Open3.popen2("AWS_REGION=eu-west-1 #{bin}/copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("AWS_REGION=eu-west-1 #{bin}/copilot pipeline init 2>&1", 1)
  end
end
