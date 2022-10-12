require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.22.1",
      revision: "ba55334906364ecdef5b4044f00f5b642d24389e"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "768260f2cdb3d922946ac3abcf8df3a472446d17e7ae84e6b1c5be075120bb8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "187cfdc4515cdf95a74363d6deffdc2cabfee332c967b2ad55042cad5f426be0"
    sha256 cellar: :any_skip_relocation, monterey:       "f36fa874666df14ac2c246dba1637d907a598a8cb503d08d17f418a2d2d6d788"
    sha256 cellar: :any_skip_relocation, big_sur:        "689279f19ca4fdc0465e91ac9f753cbf2a0e889392f5a8dfa19e00dd7496422c"
    sha256 cellar: :any_skip_relocation, catalina:       "93658c3e47172834d133f5e36c529474552faf8fe3017e86ccf3fa7a4b998eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3735c0307091467934580b6226fbfe4c58317f4d56f83193daa27182bfe8e02"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    generate_completions_from_executable(bin/"copilot", "completion")
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
