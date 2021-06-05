require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.3.tgz"
  sha256 "23044e73fb3f536a9197360d59e98dc837e7d91c4276dbf6cab6da504fce6fd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26ed7a8047c2c701553c23bd26959bb29c2d0162ef13e1afffdbd866c7140ffe"
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
