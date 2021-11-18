require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.3.tgz"
  sha256 "4ffc2c80c4e67400730818fd78135297f4f601563339885b6e53d6c8f55fa491"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f4f6308e53dbc5dc2f50d82e32024ae6932006e20451fa918cc97e981e90fda"
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
