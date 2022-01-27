require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.11.tgz"
  sha256 "3f6a4e3e3031908d448e28924c11506ed469314280e041a5f24bf336f2b95e78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d87acd3ed626b2a7d8663b798b406b1581238249a1871cb544a4d14a1928a5fd"
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
