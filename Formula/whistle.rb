require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.4.7.tgz"
  sha256 "83ac07ac9d28ba11d274ced862cb457cb34efe5e35abc81fb21481cd124a82d1"

  bottle do
    cellar :any_skip_relocation
    sha256 "91cb16e9dc79acfae70377f853d696f979dfce7f60ead8ba22c8e6bafa4524ec" => :catalina
    sha256 "b593158ea53057116b0b31fd40aeb98c662f1bc3861209863db09838a3e063dc" => :mojave
    sha256 "f84c0f7f05845c490b58e2d8bfca612400c9875b2e094a45b76ab47868526834" => :high_sierra
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
