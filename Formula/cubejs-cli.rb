require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.15.tgz"
  sha256 "d6a81b3765e84a1b721bbc96f6aa8a6cefd65484bdb029b2f946f76013e2c529"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22974207312aeb57fc7b72704519977f20b5fca10c713e31d36fbbdc5d1483bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22974207312aeb57fc7b72704519977f20b5fca10c713e31d36fbbdc5d1483bf"
    sha256 cellar: :any_skip_relocation, monterey:       "8c54840c1ca55badd846f620555496a827dcfb27ab994eb4aab57975b0480ad9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c54840c1ca55badd846f620555496a827dcfb27ab994eb4aab57975b0480ad9"
    sha256 cellar: :any_skip_relocation, catalina:       "8c54840c1ca55badd846f620555496a827dcfb27ab994eb4aab57975b0480ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22974207312aeb57fc7b72704519977f20b5fca10c713e31d36fbbdc5d1483bf"
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
