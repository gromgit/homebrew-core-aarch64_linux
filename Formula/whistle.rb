require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.2.tgz"
  sha256 "a4d116ac0d9c5f90bfa4257f382a9a8dc097362a40547639ddf0a73730089802"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bb5a4caabf84406cf9ec1b33cb8cfe7b141e519f5c327dcc25de15002987baa2" => :big_sur
    sha256 "993f82c31344b1f69de487e38117c5752ecea7bd979e1023f565f021f156e6b5" => :catalina
    sha256 "18988c38b9fb1306fea9bfbe238184ab9d82ea023d30e4068954bc043ea85834" => :mojave
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
