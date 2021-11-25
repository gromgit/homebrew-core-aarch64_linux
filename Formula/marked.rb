require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.5.tgz"
  sha256 "b5e25b272471f18e30dfd55bcec1d308ad557acc2b2f1d67fa3e20104cdd99e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a7e30e83b066608858545b50495654e858a1c2b361e03b3943c6dc2e2f7def5"
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
