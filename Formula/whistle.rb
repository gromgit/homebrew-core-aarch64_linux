require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.1.tgz"
  sha256 "d82994f3dbddf16f5a26c25278604ed08f2acfedbbde511a63efa9d1374f03d7"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8e7da2daa385440791bd1af34126f488e19a98d904c13049bfee92c400c291e1" => :big_sur
    sha256 "a96ce7bf2484db8e293772d65c6168856b13741f30345339d7dfb78e4c6a67e6" => :arm64_big_sur
    sha256 "e86167e91159f9c0578acb6d60806708f005a70d6382663b2542d09ff641e0f9" => :catalina
    sha256 "b9d34c3b3c3a9de24e6469a10557b05219f6b6d38a9ad5cc3a502a14f40e10ad" => :mojave
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
