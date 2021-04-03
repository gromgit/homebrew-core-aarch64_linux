require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.10.tgz"
  sha256 "e922e64baad9db107c30658f77fcf73bc64b7d06cf9d5a4385b0078a796e6988"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "814212d9d076cf585ad3dcf6fab288a64c06892cc7673c5dbf2d909a689c5534"
    sha256 cellar: :any_skip_relocation, big_sur:       "c56513280ba66fc20b1d37ec06f832544c20b141b19a7cf9e7812325630dccc4"
    sha256 cellar: :any_skip_relocation, catalina:      "02e22e7119dfb01decdb81cf6b22472505bdab056cfafef93d189bbc2d736ca4"
    sha256 cellar: :any_skip_relocation, mojave:        "ddc04a036aa981475f5278c8605a2753f114a9309aff0e47ef2b01bfcf8efd54"
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
