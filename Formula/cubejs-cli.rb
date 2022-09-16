require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.71.tgz"
  sha256 "95eda5940f4040abb70bcb67cde7e64389ca06873812278a4a669f6b0f7b6208"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b662b2d403a720576c626d883e546f6b503849f4f7a6d9be9cb3bb5a4f57282"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b662b2d403a720576c626d883e546f6b503849f4f7a6d9be9cb3bb5a4f57282"
    sha256 cellar: :any_skip_relocation, monterey:       "f3aed92d0c0e90dcfb4cce737ea9792a86a26ad010cd70d867d1cd8684ac62c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3aed92d0c0e90dcfb4cce737ea9792a86a26ad010cd70d867d1cd8684ac62c6"
    sha256 cellar: :any_skip_relocation, catalina:       "f3aed92d0c0e90dcfb4cce737ea9792a86a26ad010cd70d867d1cd8684ac62c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b662b2d403a720576c626d883e546f6b503849f4f7a6d9be9cb3bb5a4f57282"
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
