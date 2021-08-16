require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.0.tgz"
  sha256 "30b2c3f787c70697f14e6f5bfbd2d066e02d5b121bbea637ecb4a59dd7dcfa60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e48abe8c593c80cffb44aa0246820bcdd763c6314cb6efe4c8b49511e6a78ead"
    sha256 cellar: :any_skip_relocation, all:          "6cbc239d4c6ad70e200f880540830c506d2662f15bd0d925500b0e567fbda456"
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
