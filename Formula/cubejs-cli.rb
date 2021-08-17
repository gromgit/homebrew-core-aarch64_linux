require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.21.tgz"
  sha256 "f36bbe9a03104cb02331c657dfad6b0f82a4ac4ccc68598ad9c0d45d6bff8c56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "10dcde68e9e153a43a4c70f617a971038c569e8d2016bbac3f7c508a439004e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "68e53d656084f43dbec0e54969498d59e30026e65db00c6eb94e7a3a24e717f4"
    sha256 cellar: :any_skip_relocation, catalina:      "68e53d656084f43dbec0e54969498d59e30026e65db00c6eb94e7a3a24e717f4"
    sha256 cellar: :any_skip_relocation, mojave:        "68e53d656084f43dbec0e54969498d59e30026e65db00c6eb94e7a3a24e717f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10dcde68e9e153a43a4c70f617a971038c569e8d2016bbac3f7c508a439004e6"
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
