require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.40.tgz"
  sha256 "33d3eced1c6e186a5c7ca4bc3366dec9e115b37273dc961c93dc6455f8f5ceaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25de68bef1a5c0995cc35653452a146e7ed2469a497e0fe51a436859480c8f76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25de68bef1a5c0995cc35653452a146e7ed2469a497e0fe51a436859480c8f76"
    sha256 cellar: :any_skip_relocation, monterey:       "9ac0b267695f6148096e933177765f5bea5f15c30b71cf36f033354c1bcff3e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac0b267695f6148096e933177765f5bea5f15c30b71cf36f033354c1bcff3e0"
    sha256 cellar: :any_skip_relocation, catalina:       "9ac0b267695f6148096e933177765f5bea5f15c30b71cf36f033354c1bcff3e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25de68bef1a5c0995cc35653452a146e7ed2469a497e0fe51a436859480c8f76"
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
