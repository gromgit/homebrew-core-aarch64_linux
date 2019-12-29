require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.4.4.tgz"
  sha256 "a1216eaec1c6e651cf26c5307d6a5938c978943e03b47c57aa32575e6a6cee53"

  bottle do
    cellar :any_skip_relocation
    sha256 "33fecf9ed07f69091c10358602db04b4e4ba39eb5b84666b8d26ec485e91c659" => :catalina
    sha256 "3fa0a4cb94c5a5190949c72a400bf4d5679b969a364204d41bf1643cd018320e" => :mojave
    sha256 "a74006cdf42883daee4675066ae2d303be393a2a8c3b87ac78e44e4a6b21bea9" => :high_sierra
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
