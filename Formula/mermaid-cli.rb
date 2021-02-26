require "language/node"

class MermaidCli < Formula
  desc "Command-line interface (CLI) for mermaid"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-8.9.1.tgz"
  sha256 "3e9257bbca0d59ca377362559c9ee565a9e15c7afa5e2ebb9e6a6e4d033318da"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "503f1999378800866e6acea39608d2e7a80fc6d7956bed3ad5a9a2c3fb6f7f54"
    sha256 cellar: :any, catalina: "05015617b49fe9d215798fc16cc504afe92605fdf84fd93d1aeda3aa8c5f4e9f"
    sha256 cellar: :any, mojave:   "a1ef6b374cd599b41251985613ea840345630921499e86903cf1bd8f89048bfc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mmd").write <<~EOS
      sequenceDiagram
          participant Alice
          participant Bob
          Alice->>John: Hello John, how are you?
          loop Healthcheck
              John->>John: Fight against hypochondria
          end
          Note right of John: Rational thoughts <br/>prevail!
          John-->>Alice: Great!
          John->>Bob: How about you?
          Bob-->>John: Jolly good!
    EOS

    (testpath/"puppeteer-config.json").write <<~EOS
      {
        "args": ["--no-sandbox"]
      }
    EOS

    system bin/"mmdc", "-p", "puppeteer-config.json", "-i", "#{testpath}/test.mmd", "-o", "#{testpath}/out.svg"

    assert_predicate testpath/"out.svg", :exist?
  end
end
