require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.65.tgz"
  sha256 "14e7042bbd849d748e69ae82a2e329d519e7983242c100f638b9566e92d3f700"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "092292ca1c67482f69d89b2a9fea2eadfce0916fc1fc69c5ad5613c7f1d103c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "092292ca1c67482f69d89b2a9fea2eadfce0916fc1fc69c5ad5613c7f1d103c4"
    sha256 cellar: :any_skip_relocation, monterey:       "256644778c17cf08d9b12a956607e0341fbd744b73a8728f3cd2140c6e6f1054"
    sha256 cellar: :any_skip_relocation, big_sur:        "256644778c17cf08d9b12a956607e0341fbd744b73a8728f3cd2140c6e6f1054"
    sha256 cellar: :any_skip_relocation, catalina:       "256644778c17cf08d9b12a956607e0341fbd744b73a8728f3cd2140c6e6f1054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "092292ca1c67482f69d89b2a9fea2eadfce0916fc1fc69c5ad5613c7f1d103c4"
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
