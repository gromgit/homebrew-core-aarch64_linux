require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.22.0",
      revision: "00263a667f8c1fc9b37db8ce8c80ad3ccb5da51f"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c0cda510f47b6966ef14d3de5286c08ca1e6fb0935148742ec63ebcd7887854"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2dc3d46e1cfeaa243f017ac3c9abd16cc6252f95ece1560800d66916e491fa2"
    sha256 cellar: :any_skip_relocation, monterey:       "b45ef71297f3fe5e74c739cd5e01a000a4e691a7a1e3bee74c2695a94ef21d13"
    sha256 cellar: :any_skip_relocation, big_sur:        "6354a5a1fa31168289fd93c07e0445fe374ca1d6a23dea335f74d250ffb0dde6"
    sha256 cellar: :any_skip_relocation, catalina:       "f63a0890fb78bcc86cbd451462bab7e4f8646869ffeb64618e8bb91f08241f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50044f3dd3ce842b109c946068581ec89b86b0d384204a4d800770244b22964e"
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
