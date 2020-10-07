require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.65.1.tgz"
  sha256 "12784b2cbd1373f55d435475a112e90fc273699b1d7509e5745fd61690c6d8b6"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "901a0bc3f73d655bef3f03779b06b692cbec1ef21359c5e6458c666dec6b6086" => :catalina
    sha256 "d66d285dbd0fc98a3c94282f32e291cddaf804909e960ea511a6bea9bda36c85" => :mojave
    sha256 "ec166a760428101f455c8c74d66ed69cd38730f18299a479ddb604e54112e7fe" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
