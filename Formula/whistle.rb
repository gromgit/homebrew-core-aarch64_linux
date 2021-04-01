require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.9.tgz"
  sha256 "150b0cf15570c4e97aa04a2a49e52fb69d520ea5b4f64abec35edd8a528e3bcd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8c98e570950037c68528f08b67d89c0cc6044f232ba675e099cdd04681926fd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "f12eadb28a22929fc0b4842726af696402e192362158805d63a1080ff1ecc43b"
    sha256 cellar: :any_skip_relocation, catalina:      "f18d069d0479c411604f0119c70c7446d89bea6f33dd88355ae8653a86cb0552"
    sha256 cellar: :any_skip_relocation, mojave:        "be4bc702456243598aff5227815b24c74fa342811cab2ebbb1c6067e5b48d7fb"
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
