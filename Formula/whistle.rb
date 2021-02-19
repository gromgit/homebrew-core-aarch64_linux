require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.7.tgz"
  sha256 "cc93aa4e5ff46c80edf7754878e55494f199481b800d2ba19c0e4996358ef633"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d25cfd686f466915d102aa6dbed3a981bf8590175336c58a6ec9bda67c92d9c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "55c1a3c814402fd3b3eb7c9e55a85fc34f2f4ec6d7c690550921516f2fb30c41"
    sha256 cellar: :any_skip_relocation, catalina:      "3b2443d360313ddcf9007e41c7dbcf61d3d61f8b2b0b47a63d2aa274b30af258"
    sha256 cellar: :any_skip_relocation, mojave:        "acca70eda23b746e429ba07e79504df55e9c877da950b017c8094224bc31e101"
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
