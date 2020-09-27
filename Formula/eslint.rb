require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.10.0.tgz"
  sha256 "97314fa9096d571d5531a4523313f98ee38cda2353b8191ba85c8ab2678aa054"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f1eee3cdf6ab5f42397fcefe07bd0c55e2d4c03695785c32e227cb03a00a0d81" => :catalina
    sha256 "38464aef8e15815064f90d7bb3a8e123802363ba4131942bf78c96e4ff426a77" => :mojave
    sha256 "3a1c2a8b455dda8788818917d0e413ec4da82f24ca958fe0a585877f11491553" => :high_sierra
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
