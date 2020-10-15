require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.24.tgz"
  sha256 "d01684cb568f673824664c7027ed7c8d1b532323c840772fee86ed3b33f0d30d"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f3eaaa67c00481f922a51fdc4f8e8264a1870f42ad306376a471bedaf48642d4" => :catalina
    sha256 "861c978726b0da4951cb3466161c767bc13c841244e8e6304985edad3dcea16c" => :mojave
    sha256 "419b2a38012fa2988854fd316aebae5f8088048f8551efcf10739dac137f2f62" => :high_sierra
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
