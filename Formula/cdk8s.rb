require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.18.0.tgz"
  sha256 "c874fb4cb54c3b7fbdfa6fdffc67cd71c9e2dfd316a45d65cc8690ab1d4bc643"

  bottle do
    cellar :any_skip_relocation
    sha256 "6158254c41291adaccdbffcc346f02ec989a49422f91fa29c49d95b9f54a0c94" => :catalina
    sha256 "87d803b5ce3d0b1acdaa9c6e95fdd649de3c051aa5f7e010352be90f9d7da1ad" => :mojave
    sha256 "f9847751772e2e4041967eb2bb718d5451a206ebb06354d21dee3872aabbbbe9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/cdk8s", "import", "k8s", "-l", "python"
    assert_predicate testpath/"imports/k8s", :exist?, "cdk8s import did not work"
  end
end
