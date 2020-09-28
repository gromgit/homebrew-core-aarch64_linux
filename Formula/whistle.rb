require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.22.tgz"
  sha256 "78447631b5c18564476546038e359bab8e0bb30164c46926cef328b89e43572d"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "89f80a0761e514110c4e5838d7538c48bbd3cb6f4928df2e8b871025b104fdbe" => :catalina
    sha256 "b24a04403b87acd51316faf807f5e00c4bc244669523da4775fe729da9c10df7" => :mojave
    sha256 "8b6898ea76c4c574a457b6fa7720423697baa6b7635bcd0bfc8a7bd77b19959c" => :high_sierra
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
