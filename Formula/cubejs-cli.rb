require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.52.tgz"
  sha256 "925db9e5592caac1961cb37c7b69afbaecce2987270a146b5a674982698a8cfc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f02e7ffb918538b84f5cf2c607afcd078be202334b5b059bc1756caf690b689"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f02e7ffb918538b84f5cf2c607afcd078be202334b5b059bc1756caf690b689"
    sha256 cellar: :any_skip_relocation, monterey:       "d2eeea677655fa1c02ae697db030e4f0416c474b6e86188bbe8c64e4387a97ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2eeea677655fa1c02ae697db030e4f0416c474b6e86188bbe8c64e4387a97ad"
    sha256 cellar: :any_skip_relocation, catalina:       "d2eeea677655fa1c02ae697db030e4f0416c474b6e86188bbe8c64e4387a97ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f02e7ffb918538b84f5cf2c607afcd078be202334b5b059bc1756caf690b689"
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
