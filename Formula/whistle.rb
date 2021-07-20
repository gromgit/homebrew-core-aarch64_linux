require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.9.tgz"
  sha256 "49deb9ec40e08b91346b75407185c29ac5c99265a8f88683e2193331c084afbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69a928b90a66bf2f822b7cff339f8ac3945539ce6b7128dd7ab8749fa7073aff"
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
