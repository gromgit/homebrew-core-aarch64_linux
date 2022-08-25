require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.57.tgz"
  sha256 "8c1be8217ae8ad1f870daf6c74434e6852ba3938a4e18cbb5c790a66d476940b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec9b3de78ca594ac61ba5f4fdade5ac123720e31c49d621890746b5e1f5dc87a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec9b3de78ca594ac61ba5f4fdade5ac123720e31c49d621890746b5e1f5dc87a"
    sha256 cellar: :any_skip_relocation, monterey:       "a07fdfef15388778ae05778617b751ff79872ed1c2dfca250c685b4b7e5c8779"
    sha256 cellar: :any_skip_relocation, big_sur:        "a07fdfef15388778ae05778617b751ff79872ed1c2dfca250c685b4b7e5c8779"
    sha256 cellar: :any_skip_relocation, catalina:       "a07fdfef15388778ae05778617b751ff79872ed1c2dfca250c685b4b7e5c8779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec9b3de78ca594ac61ba5f4fdade5ac123720e31c49d621890746b5e1f5dc87a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
