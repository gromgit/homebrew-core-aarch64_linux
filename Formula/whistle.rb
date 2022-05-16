require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.16.tgz"
  sha256 "a9ef49bc2dc2e749e9c7565cd205afe70a6083dafa12164456ac805e0f78f117"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "11f4fa842ae5e2711e1b5ea28a6d87fcfbe559baa5dc6eb297db239f66cb64d8"
  end

  # `bin/proxy/mac/Whistle` was only built for `x86_64`
  # upstream issue tracker, https://github.com/avwo/whistle/issues/734
  depends_on arch: :x86_64
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
