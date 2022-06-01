require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.9.tgz"
  sha256 "938d83f9481290e61767c5158618f8670977a794a9485098df2a0712b4ca9056"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edb128607ff63af1bd7ea470299d26f9a44c31e3fc2b51012bd7a062c329a2a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edb128607ff63af1bd7ea470299d26f9a44c31e3fc2b51012bd7a062c329a2a1"
    sha256 cellar: :any_skip_relocation, monterey:       "6b8629afb0b37e3dc4cb6f0a2e71909fa39430990dd0dbd69891e17a49ce5a4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b8629afb0b37e3dc4cb6f0a2e71909fa39430990dd0dbd69891e17a49ce5a4b"
    sha256 cellar: :any_skip_relocation, catalina:       "6b8629afb0b37e3dc4cb6f0a2e71909fa39430990dd0dbd69891e17a49ce5a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb128607ff63af1bd7ea470299d26f9a44c31e3fc2b51012bd7a062c329a2a1"
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
