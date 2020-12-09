require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.24.5.tgz"
  sha256 "5b1b3b83406e2e62cccafdf9c38897f05b2c7059e04edbb248e4d70786b88f2e"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bd0e8e02789e9a0116a8535dc551a69f7625419308c369a88cb07c03731a1c80" => :big_sur
    sha256 "a2ae80d30a8e7ccb6f9aa7427fca75479e2d51b6f0d4dfefced5de13491c045f" => :catalina
    sha256 "504a87e0b56638b05cec54643b28a1b2f2bd0de008d75ececa63570594884ed3" => :mojave
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
