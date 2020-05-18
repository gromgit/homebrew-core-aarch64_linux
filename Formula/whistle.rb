require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.7.tgz"
  sha256 "8c7954f9ec0cf20055328d41393992e28a69313dc8a422aa34d46a7c5861d376"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc42d28f5ea0cec9d0118aebbea5e8f487550bfb35c2e0684a4038d85cc3b904" => :catalina
    sha256 "66f5c80be1320c66899cd916b5f70c488df12fcb56a6c78dfed12c68ee86b81b" => :mojave
    sha256 "3f4f87ddbc55a6a9a0cc4a15588deb9b634d8a34fa8ca6f3c946d573204c6146" => :high_sierra
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
