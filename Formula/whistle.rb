require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.4.16.tgz"
  sha256 "bb0b81de3663d7dd4255dbd405154adc4c4db74700fffcb6d7ea935b8f1a2df4"

  bottle do
    cellar :any_skip_relocation
    sha256 "a21b3dea4c16727f7afd02f038f15e270e7a7cfc7aa216698134e9d8fb29e37b" => :catalina
    sha256 "2ef0d3cc7a37e9102bc9f9235a795a02a96fe8cd6c046aa2510363d15b40d542" => :mojave
    sha256 "cc45a343ced2568d238424d2bb9fd11b9d6635091b64356cb8af10e77f8049c0" => :high_sierra
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
