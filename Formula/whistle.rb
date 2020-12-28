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
    rebuild 1
    sha256 "cf2c336fa779a81c2b96cf7b5c4052e60287e74fefe3c99652c275d1542a6b54" => :big_sur
    sha256 "e3811837472f44bdf219e762aee71555ed0e17181e0d677d3f2cc615fe555540" => :arm64_big_sur
    sha256 "32fdd97a68642d375403c0a252693dcfc08590290d96eb163b8ad0ccc9f9433c" => :catalina
    sha256 "856c6989452371a77ac5c2aa9e3bdb7a26c5ace476a3c318b9b4b9f0a0104772" => :mojave
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
