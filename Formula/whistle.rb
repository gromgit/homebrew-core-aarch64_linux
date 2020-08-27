require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.18.tgz"
  sha256 "8b719b9e64f6d3cfc948cb38b99dfdaacbfc3fedcfa6008ecfec0d2d0d7e0dff"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0354b7ca9e5d31242bc77d393375eef9ca9967629b31325cd6b3c8c0e2a152c8" => :catalina
    sha256 "aef98bc4ed006acbb2e5176a54d328469f6ad28c68f6e9b9beaf1af588bbe1d2" => :mojave
    sha256 "b395eff6caa0133d278c0030de299a65bf1956ff272edfff876972c5fcf71fb7" => :high_sierra
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
