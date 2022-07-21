require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.37.tgz"
  sha256 "26922d2b558ff783119cfbae2de5bbfffd4019b09324ca749347997aac6435e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff3f8f4cce6e8e37e72ae3195aadab0444d02c4d9aa9f943b3b81532c11cb076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff3f8f4cce6e8e37e72ae3195aadab0444d02c4d9aa9f943b3b81532c11cb076"
    sha256 cellar: :any_skip_relocation, monterey:       "d0582ed859dbe8931ed7b8ff1e8e44ac83e2c26a0142ffd4b032ffacc718855b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0582ed859dbe8931ed7b8ff1e8e44ac83e2c26a0142ffd4b032ffacc718855b"
    sha256 cellar: :any_skip_relocation, catalina:       "d0582ed859dbe8931ed7b8ff1e8e44ac83e2c26a0142ffd4b032ffacc718855b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff3f8f4cce6e8e37e72ae3195aadab0444d02c4d9aa9f943b3b81532c11cb076"
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
