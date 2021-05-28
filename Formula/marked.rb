require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.0.6.tgz"
  sha256 "8955f1e034f4ee88bb5d2807a95a5e3dd21fbb8ecc2ce437e2a3e90ba35611f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac77919a53b22d6e736ef36b401c5d89286bef6e7e2819bf9543ca363bc523e9"
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
