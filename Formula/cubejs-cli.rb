require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.27.tgz"
  sha256 "f3846c57eae7c7a07c57aa73b5237c5ba6fa0cb99155ed09d5dd534fa7ab6438"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fedf515d8764941b9da991fbb9f0a704c59b0424e11c4bc97c8a121f1285d490"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fedf515d8764941b9da991fbb9f0a704c59b0424e11c4bc97c8a121f1285d490"
    sha256 cellar: :any_skip_relocation, monterey:       "ba44f7fd4734d674653aad952d9e93a91c4cbdd898a5c84daaed619f82ea2a16"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba44f7fd4734d674653aad952d9e93a91c4cbdd898a5c84daaed619f82ea2a16"
    sha256 cellar: :any_skip_relocation, catalina:       "ba44f7fd4734d674653aad952d9e93a91c4cbdd898a5c84daaed619f82ea2a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fedf515d8764941b9da991fbb9f0a704c59b0424e11c4bc97c8a121f1285d490"
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
