require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.30.tgz"
  sha256 "5b4da26eb25bf7611b75265f2371d6d6dd81b1970c6439cc159fbeba2f11f3e6"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "54e162e914be3c6fc0c8528ab6062933dfe06b121084dc877f79742e2bb3990d" => :big_sur
    sha256 "c309c9873820dacbdf93769ffbafb4569e74a8173c51379478cceb450c14ff33" => :catalina
    sha256 "225da9a17f151ecfc6df3443645af7cac7c1761fa03f735947c2e5f6eb685c4a" => :mojave
    sha256 "2df3d47b69ace1712983160f35405640feba127ae0321e8c369c2b8f81b8f134" => :high_sierra
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
