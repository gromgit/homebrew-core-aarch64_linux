require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.29.0.tgz"
  sha256 "7f79ec1402aeceb763614043124cc80a99f97a157f3a497d88da2e72f5365daa"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3fed0248479d23a7dcdc828c7f65e5d3a0009c135b1ad2de5e58f3751940f7bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ead7bf0c9dd5fdbd284be53fb9ad8265a4bb532098ac2393518fd17861a8c62"
    sha256 cellar: :any_skip_relocation, catalina:      "7ead7bf0c9dd5fdbd284be53fb9ad8265a4bb532098ac2393518fd17861a8c62"
    sha256 cellar: :any_skip_relocation, mojave:        "7ead7bf0c9dd5fdbd284be53fb9ad8265a4bb532098ac2393518fd17861a8c62"
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
