require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.0.0.tgz"
  sha256 "6b4e4ad3eedcadda9ea0328f76055e18e5a151dedba0cb566b335ecb3c2d4556"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2dcb698182b265191683adaa6a8cc66f9db5cffcb711e460838a3bcd39d1900"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2dcb698182b265191683adaa6a8cc66f9db5cffcb711e460838a3bcd39d1900"
    sha256 cellar: :any_skip_relocation, monterey:       "52675fc8f6180b90e5d38b54d7f5a7a5aba76063226c4c50c957fe790d4d334f"
    sha256 cellar: :any_skip_relocation, big_sur:        "52675fc8f6180b90e5d38b54d7f5a7a5aba76063226c4c50c957fe790d4d334f"
    sha256 cellar: :any_skip_relocation, catalina:       "52675fc8f6180b90e5d38b54d7f5a7a5aba76063226c4c50c957fe790d4d334f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d9c9b6b620d218a01eb84216bcb41bea0875841a67a27f92ea71f2de3c5f45"
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
