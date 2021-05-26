require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.20.tgz"
  sha256 "f0c005ff8b5adf3d18f61789552e682971e83755134436874eecc0bbf3192ee0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2fafef8b55e87148ac75e8ac107ced3f586599263960dbcba652af1568705fca"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca2eeef34a84da82e65dd61e158a034f5a45b63d229a4627b21f4d14f31d3474"
    sha256 cellar: :any_skip_relocation, catalina:      "ca2eeef34a84da82e65dd61e158a034f5a45b63d229a4627b21f4d14f31d3474"
    sha256 cellar: :any_skip_relocation, mojave:        "ca2eeef34a84da82e65dd61e158a034f5a45b63d229a4627b21f4d14f31d3474"
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
