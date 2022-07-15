require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.35.tgz"
  sha256 "24f2e8068b9434b2c6a8ab12ca1a9df476851f66c206b3c52bce936f03c2c5f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90b9718f8cecac51ebb6e817bc254e7139ef12a1b3220a12816b8867c184a3a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90b9718f8cecac51ebb6e817bc254e7139ef12a1b3220a12816b8867c184a3a1"
    sha256 cellar: :any_skip_relocation, monterey:       "2fea84a8395cf3ca2acd9385e2d28021fbcdfe463d472831d4ac7b86e31d0b00"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fea84a8395cf3ca2acd9385e2d28021fbcdfe463d472831d4ac7b86e31d0b00"
    sha256 cellar: :any_skip_relocation, catalina:       "2fea84a8395cf3ca2acd9385e2d28021fbcdfe463d472831d4ac7b86e31d0b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90b9718f8cecac51ebb6e817bc254e7139ef12a1b3220a12816b8867c184a3a1"
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
