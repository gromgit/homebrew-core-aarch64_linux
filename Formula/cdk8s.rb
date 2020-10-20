require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.32.0.tgz"
  sha256 "88f78e0d015e5ab5bbf1c0254946b31d59c274a5fc02513204a695812b9d57fe"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1f681d54f80c75899b0adea09d04cc2b281333e6730a56d54a029498b809fc65" => :catalina
    sha256 "7e1bd40f23f010bcc81c3ee7be270876bdff3f3577c6e043c74d3afd82ec41c9" => :mojave
    sha256 "4457fac17c9ac9a61d68b09b549a227f8203d5ef80366d97a5d722151f49ce91" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
