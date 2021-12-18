require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.8.tgz"
  sha256 "85604cb9245300c4549a39d85dae7e741944c12801e54f4e2258ad18627b6c7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6865428556a8b6af82b3a11b98baea2d304d4847e7ce0b355337bfbc5a321a34"
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
