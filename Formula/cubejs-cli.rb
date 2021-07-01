require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.46.tgz"
  sha256 "e837158934f872c15b8071ebd6c3b5ad3e8df8db1e955aa063d79a594a30dc6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fa3695d3c050b5d642ccf968c69bdb8f79041f5bb20b0ab02bf5bf346070f5f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "8303123eaf5a3135a705d8bd2f93bb6682c5644157ed328f99eedc46f8416f02"
    sha256 cellar: :any_skip_relocation, catalina:      "8303123eaf5a3135a705d8bd2f93bb6682c5644157ed328f99eedc46f8416f02"
    sha256 cellar: :any_skip_relocation, mojave:        "8303123eaf5a3135a705d8bd2f93bb6682c5644157ed328f99eedc46f8416f02"
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
