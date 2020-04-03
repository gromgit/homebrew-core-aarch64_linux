require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.4.16.tgz"
  sha256 "bb0b81de3663d7dd4255dbd405154adc4c4db74700fffcb6d7ea935b8f1a2df4"

  bottle do
    cellar :any_skip_relocation
    sha256 "64b5987559d0041a408bd2d4b00b47cfd294f7771ac19a2cca27b73a855ea92f" => :catalina
    sha256 "b9dab7e76af74e6b0af2fa8fc86dd86b68a9849c5147c672a221698681b24cd7" => :mojave
    sha256 "ab21288dcb9266f27f98f431c4b9d51aea980c558b100596174a229273cfd526" => :high_sierra
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
