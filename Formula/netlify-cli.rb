require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.0.5.tgz"
  sha256 "e791666d914f16a7b377cd423fc40fe470177d4b04648a92f88d15f5cc28624d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47e9bb4ecc1bb72f3bd644b5b6016f810e75fa05f59fff1baab49ec868966f60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47e9bb4ecc1bb72f3bd644b5b6016f810e75fa05f59fff1baab49ec868966f60"
    sha256 cellar: :any_skip_relocation, monterey:       "aa3f29cdb196bf6a7f945f612554b51405b23c68072af96cb15b0b5a6445790d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b629b8928f3ba7a84754cfebf1ea0f21d137f5cecdc61f398f60f6583995f7a6"
    sha256 cellar: :any_skip_relocation, catalina:       "b629b8928f3ba7a84754cfebf1ea0f21d137f5cecdc61f398f60f6583995f7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b08e7828a7e5af44d25620d3b8274b2038d8e474f7ab8e395ee64fe9fc80c192"
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
