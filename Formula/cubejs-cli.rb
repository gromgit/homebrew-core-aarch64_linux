require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.4.tgz"
  sha256 "48e23cdebe1f3c08dcfa4e34b109828382c68dce9249661b4d12c4432e2c1ef8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21fd869d812352da2f211127142c5132577a9942d623a433130881eb7b0fcd84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21fd869d812352da2f211127142c5132577a9942d623a433130881eb7b0fcd84"
    sha256 cellar: :any_skip_relocation, monterey:       "946d4fb3568eba9614977c10029c24c32b32c174b1979234588fea5cc61399b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "946d4fb3568eba9614977c10029c24c32b32c174b1979234588fea5cc61399b1"
    sha256 cellar: :any_skip_relocation, catalina:       "946d4fb3568eba9614977c10029c24c32b32c174b1979234588fea5cc61399b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21fd869d812352da2f211127142c5132577a9942d623a433130881eb7b0fcd84"
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
