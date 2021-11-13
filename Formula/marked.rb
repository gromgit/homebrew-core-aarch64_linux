require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.2.tgz"
  sha256 "01905d4e1d509fe3d0a181dfa6becfb0b8bff804d8470ce9a46c414fd8ffd089"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5d0511bc7c269d0ab5a9ddabbb7d8d3f798c32cfadfc9580d69976bf6b5b1e3a"
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
