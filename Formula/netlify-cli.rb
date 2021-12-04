require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.0.15.tgz"
  sha256 "9ee814988d402cc5d75c2c1e0211a94e4b96db3dd2d18001b9530c56272e82eb"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "594bf56ecbd5ac74e7984306acdae8d8ff92a2af00019aceb1ec10b09ef87a01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "594bf56ecbd5ac74e7984306acdae8d8ff92a2af00019aceb1ec10b09ef87a01"
    sha256 cellar: :any_skip_relocation, monterey:       "49d20073523acb0e4791891bd993055f1a71ca0b7388a965ff1c7929ccacde59"
    sha256 cellar: :any_skip_relocation, big_sur:        "49d20073523acb0e4791891bd993055f1a71ca0b7388a965ff1c7929ccacde59"
    sha256 cellar: :any_skip_relocation, catalina:       "49d20073523acb0e4791891bd993055f1a71ca0b7388a965ff1c7929ccacde59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e8ad9313dc6129f57447c7577cdf82d0d5d36b5dccf3e6c996486c811518b65"
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
