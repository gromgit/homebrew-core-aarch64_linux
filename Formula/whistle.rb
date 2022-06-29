require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://github.com/avwo/whistle/archive/refs/tags/v2.9.24.tar.gz"
  sha256 "e1d5892b300227c658ec7975c139cabf13c4c1b07abd9501a7ebedab52632790"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b8d58714e6b860fe5dac96826c69f30a82a9abcd697bfe240e3d780a234f33c"
  end

  # `bin/proxy/mac/Whistle` was only built for `x86_64`
  # upstream issue tracker, https://github.com/avwo/whistle/issues/734
  depends_on arch: :x86_64
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
