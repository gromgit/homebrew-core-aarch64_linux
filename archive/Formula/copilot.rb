require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.17.0",
      revision: "1fdcfc0e187e34ea8135f6d6b48e3cd9508a2afa"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3f369c5bcdd2d1ff087d015b7f73788dc2627c2cd81d27ff9bddb703e66056e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0783ae060b8769e25cae69e88766a1f7024e1e613026e60871fbcd4c91d7712d"
    sha256 cellar: :any_skip_relocation, monterey:       "bed82c4288667474b988c67344b75f47237e6246fcd4c789ad7f543336717800"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d19bbe51eb6377befc401149853a25e2ad4440a906b8f14b4f54776e332cc9b"
    sha256 cellar: :any_skip_relocation, catalina:       "630ce334911241089ad92a9f478350422242a617739e6ac2348e6fe0a434827f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6095ac78955d7249b6f733852cc9fd442e2e13cf97d78e0f3d3b9787e943bb4b"
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
