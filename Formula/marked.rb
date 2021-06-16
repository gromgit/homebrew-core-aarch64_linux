require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.1.0.tgz"
  sha256 "febda707750e32c829578ffa35626ec03c32f5b65a106f81c3799d14766790e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "281edcc1e996675a7ab662210e064d60a7cc95ee17978ca75bb139e26cb4d5d2"
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
