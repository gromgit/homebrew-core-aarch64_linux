require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.21.0.tgz"
  sha256 "da367afe8cda38a8a8d75d8206c37106e67a327c7403293be621e5b1566e6d25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d463fa6983941da4f9a61e3128ad2bc73464512c320d76aad8f12b9f723a0ec3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d463fa6983941da4f9a61e3128ad2bc73464512c320d76aad8f12b9f723a0ec3"
    sha256 cellar: :any_skip_relocation, monterey:       "f96e85d5393d8a96e522ffca6ef2553fa6b661177f95d3226d7623609051bd15"
    sha256 cellar: :any_skip_relocation, big_sur:        "f96e85d5393d8a96e522ffca6ef2553fa6b661177f95d3226d7623609051bd15"
    sha256 cellar: :any_skip_relocation, catalina:       "f96e85d5393d8a96e522ffca6ef2553fa6b661177f95d3226d7623609051bd15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d463fa6983941da4f9a61e3128ad2bc73464512c320d76aad8f12b9f723a0ec3"
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
