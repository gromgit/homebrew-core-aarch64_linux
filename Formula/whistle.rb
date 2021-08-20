require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.15.tgz"
  sha256 "0850a540e197bdd9066296e2b410030a068be6cbaa500a24ff234bb0eb5dbd2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6ef7c25b4dba689e9ca913449891b815060c7797699fafe4c5d070c57f7e561"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
