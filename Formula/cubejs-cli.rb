require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.15.tgz"
  sha256 "bd5e88dfee3ee1dec8d60189ca2b68e9bca0fb658e3efc03f3fd7e9acaca96c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93d503b9144e900489b02bdcf7953bb5288c28ed8eaa08f4cb106548c8690207"
    sha256 cellar: :any_skip_relocation, big_sur:       "7bf44d20c521476cf9cd7016c616229ab5a5ac77c1e61429f57ac4e417dd9b21"
    sha256 cellar: :any_skip_relocation, catalina:      "7bf44d20c521476cf9cd7016c616229ab5a5ac77c1e61429f57ac4e417dd9b21"
    sha256 cellar: :any_skip_relocation, mojave:        "7bf44d20c521476cf9cd7016c616229ab5a5ac77c1e61429f57ac4e417dd9b21"
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
