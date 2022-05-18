require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.16.tgz"
  sha256 "ef928319c4a3bb74be5caf0f0d0ffcabae06a0d511f1c9d805fbb4054dc04f09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b2819ac663af17cda1002a55352c2e39229e9e1c59bd092472e1e42cb9897f7"
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
