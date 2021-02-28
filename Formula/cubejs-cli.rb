require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.39.tgz"
  sha256 "3667b6dc68b1b817569b11e245520c830343f96b56110e127a4921d9347746cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4fcc2e1b471f5de2fe64dc0c25257a028e541d320eee01c4080201dfe1cdb883"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d096e073234e0a71aedcfc45cc798e7a41443a30987132c91b5a24913eb0af9"
    sha256 cellar: :any_skip_relocation, catalina:      "635ad11a0e808c52ae5478339ed15a72cb1884a0f064775ca182eb92a88187ba"
    sha256 cellar: :any_skip_relocation, mojave:        "60f0c9e86b4f718e458bca03416615157f7e64d11e19e16d15730492851b9fdc"
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
