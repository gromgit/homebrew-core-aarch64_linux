require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.23.1.tgz"
  sha256 "7903900189ed46fea49d079c1c3247eff6822d93d61730cd118833fd7c8b5a86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b71dbff17f71f728c4bf0a65fcd5fad775df3a9da7741d646f054d92cbb35049"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b71dbff17f71f728c4bf0a65fcd5fad775df3a9da7741d646f054d92cbb35049"
    sha256 cellar: :any_skip_relocation, monterey:       "e5c64ffab315cabe26b717dbfc854c3e6708bb93f99b99db1dd3faa39cdd71ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5c64ffab315cabe26b717dbfc854c3e6708bb93f99b99db1dd3faa39cdd71ca"
    sha256 cellar: :any_skip_relocation, catalina:       "e5c64ffab315cabe26b717dbfc854c3e6708bb93f99b99db1dd3faa39cdd71ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b71dbff17f71f728c4bf0a65fcd5fad775df3a9da7741d646f054d92cbb35049"
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
