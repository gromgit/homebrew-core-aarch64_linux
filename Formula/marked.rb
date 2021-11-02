require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.0.tgz"
  sha256 "224c119ba61e79bb17dd64277adc4bd20070a5d0bc051a2f33d63025f4fd4e00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b0c89bddf7ce33b125d128ca6a9c2d7ae29c9dda3b8089c75c23a5b19c88740"
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
