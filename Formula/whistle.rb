require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.21.tgz"
  sha256 "3100108a22ec1d1e391762642e769afaa653277fcdd88566399b58f600843dd1"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0d25a3f2b01822cdf757f8422bf77fbe8f53ff54193fb43692b5539170765445" => :catalina
    sha256 "824f4a9d2029a9206caa2ebc7300d2768b9dd7fc5794933a02ecb3062e7472c5" => :mojave
    sha256 "67860a3bb12175bdd1a6bebc2c7011f2129270c5f03995919f8200dff066f354" => :high_sierra
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
