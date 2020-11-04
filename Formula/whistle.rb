require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.28.tgz"
  sha256 "9f7557b9124892c86dd76ef61f8ceb849559d2aeab7169660b28462b8254aff2"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "008e75d5b2ae3107f045b64629ec80c85646d55c2ff6023efc0b355104a80b43" => :catalina
    sha256 "5a6d2dcccf26aa021f84f1b246eb7f3f054e26285aa98b6356f7949010abfe71" => :mojave
    sha256 "992cf0ddb741f1552dbd215d1ae45ee9bbf1705440892507d43565cc7d2210f1" => :high_sierra
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
