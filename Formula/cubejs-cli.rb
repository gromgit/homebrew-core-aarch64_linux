require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.1.tgz"
  sha256 "6eec8722d2a6c3a813f846a81203412cb7bc5304ffef8eb00ce5283213b8376c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5308ed862f90f254c75800ba163877c624ec8921b6e9818ad34031e2e3190ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5308ed862f90f254c75800ba163877c624ec8921b6e9818ad34031e2e3190ec"
    sha256 cellar: :any_skip_relocation, monterey:       "69623820cfe2d675bcdb6819b9a6e00ef165b7231edb6d01d68721a1091620da"
    sha256 cellar: :any_skip_relocation, big_sur:        "69623820cfe2d675bcdb6819b9a6e00ef165b7231edb6d01d68721a1091620da"
    sha256 cellar: :any_skip_relocation, catalina:       "69623820cfe2d675bcdb6819b9a6e00ef165b7231edb6d01d68721a1091620da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5308ed862f90f254c75800ba163877c624ec8921b6e9818ad34031e2e3190ec"
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
