require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.29.0.tgz"
  sha256 "c5986a1edd120dc173d3c3abae19200f12f2703c5bff0ec71c64bd2bee70eac2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "29bb6cd3181059dfeef25b7ff56a8d9861ef963f2502c81b878d0b7af3de4675"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1277e4acef503fcde6f0600c96bd31fe45d3f8b9417938310d72f589b8f1417"
    sha256 cellar: :any_skip_relocation, catalina:      "b1277e4acef503fcde6f0600c96bd31fe45d3f8b9417938310d72f589b8f1417"
    sha256 cellar: :any_skip_relocation, mojave:        "b1277e4acef503fcde6f0600c96bd31fe45d3f8b9417938310d72f589b8f1417"
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
