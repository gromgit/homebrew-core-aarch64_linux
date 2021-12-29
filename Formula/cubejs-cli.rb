require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.14.tgz"
  sha256 "9eb8a288e95f2e072c31286cae4c6254a5466fca04feb0e83691e66c56837baa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6f523dc4269668aae0d1a37f937813d4cd721ff1070b87005f1d04d35f684db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6f523dc4269668aae0d1a37f937813d4cd721ff1070b87005f1d04d35f684db"
    sha256 cellar: :any_skip_relocation, monterey:       "11270c68f4ac0a589982106b3e692605622dfecc45bd29d2d57eb312db32b2ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "11270c68f4ac0a589982106b3e692605622dfecc45bd29d2d57eb312db32b2ee"
    sha256 cellar: :any_skip_relocation, catalina:       "11270c68f4ac0a589982106b3e692605622dfecc45bd29d2d57eb312db32b2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f523dc4269668aae0d1a37f937813d4cd721ff1070b87005f1d04d35f684db"
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
