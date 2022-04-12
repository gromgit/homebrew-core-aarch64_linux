require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.46.tgz"
  sha256 "e49672e4159132f3eae6a103b299e478fef0b6ce61866b02b8fd7647d8a1745c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219175cf41c3e14df402e3ba177308be2ed8a875f1d6dca408159bfb0ba13e8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "219175cf41c3e14df402e3ba177308be2ed8a875f1d6dca408159bfb0ba13e8e"
    sha256 cellar: :any_skip_relocation, monterey:       "8d3d6cde4fb2bd486101672e87c28bf7ef4e3cc2e97fc109f5ce8bb6a8d2fcb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d3d6cde4fb2bd486101672e87c28bf7ef4e3cc2e97fc109f5ce8bb6a8d2fcb8"
    sha256 cellar: :any_skip_relocation, catalina:       "8d3d6cde4fb2bd486101672e87c28bf7ef4e3cc2e97fc109f5ce8bb6a8d2fcb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "219175cf41c3e14df402e3ba177308be2ed8a875f1d6dca408159bfb0ba13e8e"
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
