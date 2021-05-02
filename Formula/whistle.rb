require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.15.tgz"
  sha256 "aaf456cde97aa93b2aec9fa94df84c23d2fd3b69976d5cd4795055cc89de5705"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ddc9b441830836a9ea783c406626abe7076a8051a9bcd6f8c09fd1a446e50f5e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ddc9b441830836a9ea783c406626abe7076a8051a9bcd6f8c09fd1a446e50f5e"
    sha256 cellar: :any_skip_relocation, catalina:      "ddc9b441830836a9ea783c406626abe7076a8051a9bcd6f8c09fd1a446e50f5e"
    sha256 cellar: :any_skip_relocation, mojave:        "ddc9b441830836a9ea783c406626abe7076a8051a9bcd6f8c09fd1a446e50f5e"
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
