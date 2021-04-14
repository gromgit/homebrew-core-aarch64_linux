require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.12.tgz"
  sha256 "c69ada8830332c285267ec28e6eb76ed2ecb1a162e5ff064c05ab5990fabb8ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e6e0fd47f55eddd68d727c59e4b50c670d6efdd55214fd5c46bca6ac61347bc8"
    sha256 cellar: :any_skip_relocation, big_sur:       "293e1983459f089ed1cf3965edc439b01b593a5ac5204aa3fcde33d3ad3a1c8e"
    sha256 cellar: :any_skip_relocation, catalina:      "85cf5906eba467a032449ad8a0675b070427045b1d1dc7d089ad05e88e065df5"
    sha256 cellar: :any_skip_relocation, mojave:        "3c991dd8a9256490df8280504757ef3ef8421593c4d5d012f496ee1216435719"
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
