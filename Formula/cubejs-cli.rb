require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.75.tgz"
  sha256 "83ca1ad0283cb4ee17753d697ceace1650c385b2c83abbcb5a2048627b53b527"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c311156d5428ea066a7886579208849fa0b55a0682a5391e229de442f523af5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c311156d5428ea066a7886579208849fa0b55a0682a5391e229de442f523af5a"
    sha256 cellar: :any_skip_relocation, monterey:       "e96511cd396afce73834d68f2c43f63a45aabcf3895a3d62f9341b089b384d54"
    sha256 cellar: :any_skip_relocation, big_sur:        "e96511cd396afce73834d68f2c43f63a45aabcf3895a3d62f9341b089b384d54"
    sha256 cellar: :any_skip_relocation, catalina:       "e96511cd396afce73834d68f2c43f63a45aabcf3895a3d62f9341b089b384d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c311156d5428ea066a7886579208849fa0b55a0682a5391e229de442f523af5a"
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
