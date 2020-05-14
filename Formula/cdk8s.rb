require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.21.0.tgz"
  sha256 "9c5be29e6a577a4ce469ee8e87545ae83854147d9529b50a1903adde00877094"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3a0f22dbc924851e701601a4d969ae798a252b29fdae6d0bf2d8ab4bbec8e2b" => :catalina
    sha256 "411f4d3206321741039d6b490059d8b95601252a510384dfdad03734d9c4200b" => :mojave
    sha256 "a0ecb3a454fb5c4170a5a7faf5a2a1c9bc1b69a588ff9d185f88bb48b89e03ea" => :high_sierra
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
