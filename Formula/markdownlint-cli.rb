require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.25.0.tgz"
  sha256 "f3a849acf2915b60e12622688c2fdcc10ad7162fad61e5df415676460c3592a3"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "be59aed4f278ac2de86f37b9f1a1f898fd250d9054713ee53c24db965837e9d0" => :big_sur
    sha256 "0caeb7da8c602a705b14cdd12e0192c6e785be1c0e3da4101747f59df18df0e0" => :catalina
    sha256 "fc935b883eb497dde56b4aad7392cbfda610eec0efc5039bbfda849ede091587" => :mojave
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
