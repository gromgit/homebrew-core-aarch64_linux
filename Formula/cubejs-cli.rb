require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.5.tgz"
  sha256 "0f6a319ae762c2a7d98a80acc193cd648f9e6700979fd18976d2ca7bd290db67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65bea052f7fdf4e611a4d560f969d2f22d57875a030978547f8fa6583e62e014"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65bea052f7fdf4e611a4d560f969d2f22d57875a030978547f8fa6583e62e014"
    sha256 cellar: :any_skip_relocation, monterey:       "e80e017bcb1cba1052f04443f359f9ffff7352511be2dd4289df837a7760a846"
    sha256 cellar: :any_skip_relocation, big_sur:        "e80e017bcb1cba1052f04443f359f9ffff7352511be2dd4289df837a7760a846"
    sha256 cellar: :any_skip_relocation, catalina:       "e80e017bcb1cba1052f04443f359f9ffff7352511be2dd4289df837a7760a846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65bea052f7fdf4e611a4d560f969d2f22d57875a030978547f8fa6583e62e014"
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
