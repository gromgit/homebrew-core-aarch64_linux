require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.14.tgz"
  sha256 "b19e5b255af539910bf0c02e57aefff0d831b3f37490424d3b3aa4854ad5b5f6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ea4cf29e5a865a012e7bf3f7aa63fe43b7d88dc6bced186b321976a863b4dbd" => :catalina
    sha256 "740a853968b524d907b67718ea54ff29fc3458c924e56217e9bc67b9b67e807b" => :mojave
    sha256 "754785aca1c8629735f1b400e3ed260ccb5b988320f38ba097f2996066ec241d" => :high_sierra
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
