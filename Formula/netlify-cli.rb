require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.37.27.tgz"
  sha256 "eeafff375ce1068b8aa7f18ec6b487178ea0697b12b1e0a4fa55dccdc332d187"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4202c1012ee3b93402c56c6871cd7fa82f72760e679e1232d25d463a25fd4192"
    sha256 cellar: :any_skip_relocation, big_sur:       "28f6fe08099141d2723fe31a3c616118ccbe34f450c53636264fb9b3488328dd"
    sha256 cellar: :any_skip_relocation, catalina:      "28f6fe08099141d2723fe31a3c616118ccbe34f450c53636264fb9b3488328dd"
    sha256 cellar: :any_skip_relocation, mojave:        "28f6fe08099141d2723fe31a3c616118ccbe34f450c53636264fb9b3488328dd"
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
