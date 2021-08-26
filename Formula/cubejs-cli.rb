require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.28.tgz"
  sha256 "c76c06b9282b7bc17e3f2e118e7853175d14d2ba18abbf96e57da0a61540ea14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b347d01a3268616f63f987d22aff0e959b3b0a6f43dfdddc8f8f73d16149050"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb7cf8255049f61cc56df1c415d0ae0a0e58ea66b26bf582834ae8ca390af4a4"
    sha256 cellar: :any_skip_relocation, catalina:      "bb7cf8255049f61cc56df1c415d0ae0a0e58ea66b26bf582834ae8ca390af4a4"
    sha256 cellar: :any_skip_relocation, mojave:        "bb7cf8255049f61cc56df1c415d0ae0a0e58ea66b26bf582834ae8ca390af4a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b347d01a3268616f63f987d22aff0e959b3b0a6f43dfdddc8f8f73d16149050"
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
