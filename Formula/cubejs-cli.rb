require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.1.tgz"
  sha256 "9fda62f6f1abe745b540c94a3b85ea4f48a8372fb1c2af4031287ac70542b5f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9197f2651619ba8652b7556a6da1f57b858e6d7f67921591e7b8084754eed8e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9197f2651619ba8652b7556a6da1f57b858e6d7f67921591e7b8084754eed8e0"
    sha256 cellar: :any_skip_relocation, monterey:       "4f1f9df311c912eb463575ccf780e90d7ace871af226e1ffa4df81c7b39de0d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f1f9df311c912eb463575ccf780e90d7ace871af226e1ffa4df81c7b39de0d7"
    sha256 cellar: :any_skip_relocation, catalina:       "4f1f9df311c912eb463575ccf780e90d7ace871af226e1ffa4df81c7b39de0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9197f2651619ba8652b7556a6da1f57b858e6d7f67921591e7b8084754eed8e0"
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
