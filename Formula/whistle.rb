require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.19.tgz"
  sha256 "a8e4e92732467347cf365fe9954b2b2afd9dd795ffb356f9ff234e8cf68acd9e"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0be5076469b5e823f29bb356232a34757aa891251dcca60bcd290c4c63e759ce" => :catalina
    sha256 "2dcbad31cba5d91e9c464d0cd96ffafa994db30d1fc5cc5f149e10177575f8fd" => :mojave
    sha256 "ce10b57a51773ce7994d6ba0f3d121d67846714267631a1acf322f0a1db33fb9" => :high_sierra
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
