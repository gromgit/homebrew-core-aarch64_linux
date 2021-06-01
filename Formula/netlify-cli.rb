require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.32.6.tgz"
  sha256 "bcca501f0bc822a10df9db52ab62d5638dc9d1867016467ad7282b95a0895a1d"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da3179fc311bc5fb82f10ad0fb1aff3dd3843926b711d4c47acdb7231f67f30b"
    sha256 cellar: :any_skip_relocation, big_sur:       "7d4aa29f29c5b4bcbfcb6198db6f0d9822d3531ece8b887c99e8a1aca3125f24"
    sha256 cellar: :any_skip_relocation, catalina:      "7d4aa29f29c5b4bcbfcb6198db6f0d9822d3531ece8b887c99e8a1aca3125f24"
    sha256 cellar: :any_skip_relocation, mojave:        "7d4aa29f29c5b4bcbfcb6198db6f0d9822d3531ece8b887c99e8a1aca3125f24"
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
