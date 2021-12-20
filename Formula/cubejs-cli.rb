require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.7.tgz"
  sha256 "ea7f35b740ea462d519803715f60499eb4efacf7a743dbe506046a05ed990a72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1ce162f25567e91b3b505dfddf78f87f4ce49fec41e04d0a09a73051f2e835c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1ce162f25567e91b3b505dfddf78f87f4ce49fec41e04d0a09a73051f2e835c"
    sha256 cellar: :any_skip_relocation, monterey:       "fd014401a7d66cd27344634cb6d3f512b788285087260e1cb3eda18a8c6fb5ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd014401a7d66cd27344634cb6d3f512b788285087260e1cb3eda18a8c6fb5ee"
    sha256 cellar: :any_skip_relocation, catalina:       "fd014401a7d66cd27344634cb6d3f512b788285087260e1cb3eda18a8c6fb5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1ce162f25567e91b3b505dfddf78f87f4ce49fec41e04d0a09a73051f2e835c"
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
