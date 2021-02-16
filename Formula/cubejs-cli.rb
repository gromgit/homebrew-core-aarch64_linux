require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.15.tgz"
  sha256 "6acbda08d79a546d7024830f8e7b4f16aae0d7583ee64dd177f8d41b85368524"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "916c8a2ed7fef72a7fa4ae29504aaf7fa9fbe2d8c6269aaa1d0d279e243c0705"
    sha256 cellar: :any_skip_relocation, big_sur:       "f15b5612f126a3b25e27345bf5860a5b9e77e5673687e8483806d159001fde85"
    sha256 cellar: :any_skip_relocation, catalina:      "7c1cf3b043eb17c40a3bd65b186571482cad23da9171a5436053313e7f5cf506"
    sha256 cellar: :any_skip_relocation, mojave:        "1d4f9d8ce70b998b1a5f1560e864a076813b2eabc5d89c33e73c0a61c6674eff"
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
