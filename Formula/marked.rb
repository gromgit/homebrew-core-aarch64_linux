require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.0.4.tgz"
  sha256 "fe5d5ffb3a6f0ab8c13457b5ec86638e2d83fe4d4e444cd87d504584a0b1c8ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b13c4b0bc8442f668bca33e6d6ab78468f48ae34c35c0f1a4cb8fa95cde4a6a"
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
