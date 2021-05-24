require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.0.tgz"
  sha256 "28c8827bc10ad827e0f3e81fb7886b7d1e68c6681a32fdaa520982664a9f72aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d6f04dd2be8935b0c22e343f9033c7fa86bfa56bb747ba222d2029e483b2e85"
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
