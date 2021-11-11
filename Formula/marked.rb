require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.1.tgz"
  sha256 "20932f2d56b7ded5cd6afefc7a2b0eef4b670c9766ba176eb2906f1b5ce12c18"
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
