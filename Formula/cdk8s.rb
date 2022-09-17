require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.113.tgz"
  sha256 "af95a04d8e10bd68d68e5221b8c320df992e644b6f6f4a501475668e95afdb8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2110d46937896b8ba99b46d8fbe7a02a9553a4168471472ce1cecdea081c955f"
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
