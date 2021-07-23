require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.10.tgz"
  sha256 "fc249c7bf1fcaae7220b4965ad74444d29f0e63ecb641d68821509baf42a0334"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "794b90fb4614cf3c0c04a7cc85cdfeac4da4ba52a5abbe7d1b296fdbd29d0bea"
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
