require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.0.tgz"
  sha256 "28c8827bc10ad827e0f3e81fb7886b7d1e68c6681a32fdaa520982664a9f72aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22d89974267673cc59bd27f8c988209b2fd87c2efe278c7756ca00b6d34a8a07"
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
