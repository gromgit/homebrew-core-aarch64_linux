require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.14.tgz"
  sha256 "9eb8a288e95f2e072c31286cae4c6254a5466fca04feb0e83691e66c56837baa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7f3fed279211b16489a0b38ab60599982b1a432761acf3bf730167fa13cf78e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7f3fed279211b16489a0b38ab60599982b1a432761acf3bf730167fa13cf78e"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe42407cf5fd261f27d1d70605c5e1d8ca3d556b999169af4fa35a14d595735"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbe42407cf5fd261f27d1d70605c5e1d8ca3d556b999169af4fa35a14d595735"
    sha256 cellar: :any_skip_relocation, catalina:       "cbe42407cf5fd261f27d1d70605c5e1d8ca3d556b999169af4fa35a14d595735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7f3fed279211b16489a0b38ab60599982b1a432761acf3bf730167fa13cf78e"
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
