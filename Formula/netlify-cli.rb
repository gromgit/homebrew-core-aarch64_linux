require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-4.1.0.tgz"
  sha256 "d5e96e2b96ce13c02d5a55177911bae5016d4cd5a623d4d4d025ad66eab3ca79"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aad874b15c1684d6bd8b6e013da159b9e0a8ed14e77fcf5dc7e40e00405a9fb7"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ddc1a1ef48592cd9bee1e0164a606991dff164b24e3e477939d376e59fb17f0"
    sha256 cellar: :any_skip_relocation, catalina:      "0ddc1a1ef48592cd9bee1e0164a606991dff164b24e3e477939d376e59fb17f0"
    sha256 cellar: :any_skip_relocation, mojave:        "f23684849c8d1cc1427450a063708162fd435ff232cd033fdc97b9768b5ffe9e"
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
