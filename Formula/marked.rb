require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.7.tgz"
  sha256 "522a2f849bdef76452bb66777306c9468937db1b6d77767760cf9cc651df6df3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0fd8776a84de3acd60643b98aa660e0ae78d688db66eb9b4971cda09a23bb7b"
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
