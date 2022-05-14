require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.0.0.tgz"
  sha256 "23a2a0f8b62a2192f001ab0811051b085c11de6203b8358417ade21c0083be7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfae8ee6fe44de4d1320b4eace28044287b4b712081786152550564701c0bae8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfae8ee6fe44de4d1320b4eace28044287b4b712081786152550564701c0bae8"
    sha256 cellar: :any_skip_relocation, monterey:       "a311e22809e11f956962a5b627023fc25b423f1ae1b6ac77a39418b578e7438a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a311e22809e11f956962a5b627023fc25b423f1ae1b6ac77a39418b578e7438a"
    sha256 cellar: :any_skip_relocation, catalina:       "a311e22809e11f956962a5b627023fc25b423f1ae1b6ac77a39418b578e7438a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfae8ee6fe44de4d1320b4eace28044287b4b712081786152550564701c0bae8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/bash-language-server start", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
