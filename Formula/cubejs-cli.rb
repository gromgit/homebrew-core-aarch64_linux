require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.63.tgz"
  sha256 "8c152e48d459479eee5b8795892d6b3c74a48dac26138adc8f72fd7bbb0b0b1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "299462e29dfacc9884d44ec5ad53edfd4e436bd14d2e459d3064fdee64ee8e44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "299462e29dfacc9884d44ec5ad53edfd4e436bd14d2e459d3064fdee64ee8e44"
    sha256 cellar: :any_skip_relocation, monterey:       "c83f8e6028842903c28a7ec0ecd69f8f20f539ce1ed0f53053f508af1c1ee8cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c83f8e6028842903c28a7ec0ecd69f8f20f539ce1ed0f53053f508af1c1ee8cf"
    sha256 cellar: :any_skip_relocation, catalina:       "c83f8e6028842903c28a7ec0ecd69f8f20f539ce1ed0f53053f508af1c1ee8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "299462e29dfacc9884d44ec5ad53edfd4e436bd14d2e459d3064fdee64ee8e44"
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
