require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.18.0",
      revision: "762e6cb39cf2571c6ef93b561b4aa3358b6ac53a"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bc5a5813285d8001747038d5fe53e78dd3c4052f2cb7a6213aca19711410343"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "856d3f02d2136b6bbf40d6cfc3b79894f6625bcc48e29ded24980e7aa12b2628"
    sha256 cellar: :any_skip_relocation, monterey:       "368fdbf67b5239fe0f9b3ec5cbb14a6ad471501334abc6c9013358f1de03e1b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff0afda0c6bd877de8092c0f9ba056d420dd92901a616178c6bf64544b818f9f"
    sha256 cellar: :any_skip_relocation, catalina:       "06eee1842202cdd98a76a4f71d85c18bc4e1b2b39c1a2a5dc1eda037f844fdf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b14f189fc04f9434382d7329c6ace2ef54c47d3f43d631598bec93bd9945427"
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
    begin
      _, stdout, wait_thr = Open3.popen2("AWS_REGION=eu-west-1 #{bin}/copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository.", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("AWS_REGION=eu-west-1 #{bin}/copilot pipeline init 2>&1", 1)
  end
end
