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
    sha256 "1e1bdca8e06999ff525294a9478db87ebd6c66b2d31b6a0cd1ad357363f2ba52" => :big_sur
    sha256 "2fa9096d14bd01e1169a54acd6cea1e6147caa12497803ad5bf523a85bf9e481" => :catalina
    sha256 "cca5af6b9ad80b479600ddc2707f4f1b703c68faadb4e142e4555c1ce28477ac" => :mojave
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
