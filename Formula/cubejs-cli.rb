require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.53.tgz"
  sha256 "323af630ba456ba8477e92dbf545a294808c483158db76fa7495966f3b2babbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b263de86bcdc3f0308ee8f51a4b42a547e3fbd9462ba0338cacb7d0e5e330178"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b263de86bcdc3f0308ee8f51a4b42a547e3fbd9462ba0338cacb7d0e5e330178"
    sha256 cellar: :any_skip_relocation, monterey:       "5a913f4cf596b2740e9e154f723f452b63ef3bdf403ce3e754a7706fec972570"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a913f4cf596b2740e9e154f723f452b63ef3bdf403ce3e754a7706fec972570"
    sha256 cellar: :any_skip_relocation, catalina:       "5a913f4cf596b2740e9e154f723f452b63ef3bdf403ce3e754a7706fec972570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b263de86bcdc3f0308ee8f51a4b42a547e3fbd9462ba0338cacb7d0e5e330178"
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
