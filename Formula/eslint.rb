require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.19.0.tgz"
  sha256 "02b6e3634393d4fbc1d03a2040fe0e0da754aead2d04ed08de5d5dfb9bfd8308"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55c754e7efcb3f3a0596570036e7fd1aae7cd9dd603d68c90411931ecd70a698"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55c754e7efcb3f3a0596570036e7fd1aae7cd9dd603d68c90411931ecd70a698"
    sha256 cellar: :any_skip_relocation, monterey:       "46612164cbf9033f048100dd22c3fe4a59afb79492c74da62de77902cc2354c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "46612164cbf9033f048100dd22c3fe4a59afb79492c74da62de77902cc2354c5"
    sha256 cellar: :any_skip_relocation, catalina:       "46612164cbf9033f048100dd22c3fe4a59afb79492c74da62de77902cc2354c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c754e7efcb3f3a0596570036e7fd1aae7cd9dd603d68c90411931ecd70a698"
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
