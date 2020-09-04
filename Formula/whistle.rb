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
    sha256 "a9341187c1eb5b5628e4511a8be707ddce3ae570f12571adbc16b65ff612a6fe" => :catalina
    sha256 "2f41af30cd3729a7559fe4bb62b83a7ab809ee5a41699187d71a284c58fa26fb" => :mojave
    sha256 "bce1034e2b8add7e3be0d6d4411cfcd801336ccad49fda5f4dc852635f9acf98" => :high_sierra
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
