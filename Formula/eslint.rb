require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.31.0.tgz"
  sha256 "e1059b5a9e9fec962b702c9d2e850876563e5a86ce1fe45f3851aef3b0bd0cd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "393e06101602c7f507b8b388bd1df1315a892e5750e913e937f706ccd605d429"
    sha256 cellar: :any_skip_relocation, big_sur:       "41fbaa9945c23e51be242b7756654113933d2b83818ad012ce6b19929e74042d"
    sha256 cellar: :any_skip_relocation, catalina:      "41fbaa9945c23e51be242b7756654113933d2b83818ad012ce6b19929e74042d"
    sha256 cellar: :any_skip_relocation, mojave:        "41fbaa9945c23e51be242b7756654113933d2b83818ad012ce6b19929e74042d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004f00679a268a9e087ac3a28793165f12e159e02193f73d05bd05dd32336b32"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
