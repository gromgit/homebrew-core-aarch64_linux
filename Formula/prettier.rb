require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.3.2.tgz"
  sha256 "f9c9840aac09de4d88f7d8af2957a93dd8bc57ef5bc1f8d5b3984c7c2a509f8f"
  license "MIT"
  head "https://github.com/prettier/prettier.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a5a48cc4edc02073ef5d1b0920456096d79db7ab262326802d4fc243fcf0af4"
    sha256 cellar: :any_skip_relocation, big_sur:       "f186e1743abb6f2ee9af3da64e34deb7f82c1c443461168de22829d4fa59980e"
    sha256 cellar: :any_skip_relocation, catalina:      "f186e1743abb6f2ee9af3da64e34deb7f82c1c443461168de22829d4fa59980e"
    sha256 cellar: :any_skip_relocation, mojave:        "f186e1743abb6f2ee9af3da64e34deb7f82c1c443461168de22829d4fa59980e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
