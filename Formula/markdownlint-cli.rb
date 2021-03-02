require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.27.0.tgz"
  sha256 "ca26cea17d987191e8b504da834729af79670d141e6d693b2c07cc2a0cb8a442"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b32c7699f2129d7728a4ab63846d1611becfc4cc4f01e3c2f752d7da209c1f19"
    sha256 cellar: :any_skip_relocation, big_sur:       "64694b55b90f8d406f4eb1d622de12a887b87307f324e3cc6ce6c0e96092aaf3"
    sha256 cellar: :any_skip_relocation, catalina:      "a5e680650b4a1f8b1cbb56cda18bd8853c5a9dde962a018b4ccdd682c1b0847c"
    sha256 cellar: :any_skip_relocation, mojave:        "61a7787aad97d225fad9e8258f4535fefdc75e8bc38e7a621e6aa1f2606633ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test-bad.md").write <<~EOS
      # Header 1
      body
    EOS
    (testpath/"test-good.md").write <<~EOS
      # Header 1

      body
    EOS
    assert_match "MD022/blanks-around-headings/blanks-around-headers",
                 shell_output("#{bin}/markdownlint #{testpath}/test-bad.md  2>&1", 1)
    assert_empty shell_output("#{bin}/markdownlint #{testpath}/test-good.md")
  end
end
