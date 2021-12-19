require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.8.tgz"
  sha256 "ffc82f2a4981c0981328997b2a578409b38f888b493cd9b337949e9c573d12aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbd2663c9bca24de5c67416e193324a9481b26ece4b13988dbea4d26643dd8d4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
