require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.33.tgz"
  sha256 "d8938df9600087f9fb72cf79b14f03af037b4e007d7d5f04be2ecc0bc5f85d69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a71c0a1bf1b7ce7b58b1491ee2b015be6c2b62b7ab76f97bcccb5fe6eb054e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a71c0a1bf1b7ce7b58b1491ee2b015be6c2b62b7ab76f97bcccb5fe6eb054e8"
    sha256 cellar: :any_skip_relocation, monterey:       "7f0767c950bf7dde30d072f4f272b348a4cfe425eda7172aa4e3c1429b54048e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f0767c950bf7dde30d072f4f272b348a4cfe425eda7172aa4e3c1429b54048e"
    sha256 cellar: :any_skip_relocation, catalina:       "7f0767c950bf7dde30d072f4f272b348a4cfe425eda7172aa4e3c1429b54048e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a71c0a1bf1b7ce7b58b1491ee2b015be6c2b62b7ab76f97bcccb5fe6eb054e8"
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
