require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.47.tgz"
  sha256 "c47e7212cf37e9a74ad72afb9e842ef5004d6fda67f25b4a4d7ee6d8d55c0c6c"
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
