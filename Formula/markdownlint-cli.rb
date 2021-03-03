require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.27.1.tgz"
  sha256 "0664f88d81ff13097bdf6fd59fe1f7174e9cfdb861092b7a5df9b25b87987482"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c0083fd913cded2f954f9d334530b916e9f239e999f74f9686f371e2c81cb10"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc3e0ac3404144533dfb3637d783f63cfc77415c8f922b389417806a0d58cf33"
    sha256 cellar: :any_skip_relocation, catalina:      "2ad2030d4e550a99d8227bed3943fe85042b136fdfa1328cb25ae444d8eb0458"
    sha256 cellar: :any_skip_relocation, mojave:        "e6d45fc77924cf614b7516f2771f9111e75a56ea778cf9b378d2a849488466cb"
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
