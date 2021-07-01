require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.8.2",
      revision: "3d9721285d30bfabeca677053ccf8daba5133200"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1daae8e25927025866e1ea6bb2ffe80458ceb5bb7530166beaaa9f7f5c067b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f014a96bf88088a04ce15b5c819f51a7837d63d05c0ed24e5892c6836148a1d"
    sha256 cellar: :any_skip_relocation, catalina:      "15d6d9df85b83158108f992e81b95a63c342eefb42861764f0ec06ca2404f71e"
    sha256 cellar: :any_skip_relocation, mojave:        "db0aa281480f7d4bf4b8bb2046b7563edb24fb2a03dba1fbadfd6530a4cd02bd"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/copilot", "completion", "bash")
    (bash_completion/"copilot").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/copilot", "completion", "zsh")
    (zsh_completion/"_copilot").write output
  end

  test do
    assert_match "Welcome to the Copilot CLI! We're going to walk you through some questions",
      shell_output("#{bin}/copilot init 2>&1", 1)

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("#{bin}/copilot pipeline init 2>&1", 1)
  end
end
